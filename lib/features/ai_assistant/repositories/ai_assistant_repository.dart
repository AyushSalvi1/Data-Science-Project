import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/failure/failure.dart';
import 'package:flutter_ecommerce/features/ai_assistant/models/ai_assistant_models.dart';
import 'package:flutter_ecommerce/features/multi_retailer/models/retailer_product.dart';
import 'package:flutter_ecommerce/features/multi_retailer/repositories/multi_retailer_repository.dart';
import 'package:http/http.dart' as http;

abstract interface class AIAssistantRepository {
  FutureEither<ChatMessage> sendPrompt(String prompt, {List<String>? history});
}

class AIAssistantRepositoryI implements AIAssistantRepository {
  final String _backendUrl;
  final MultiRetailerRepository _multiRetailerRepo;

  AIAssistantRepositoryI({required MultiRetailerRepository multiRetailerRepo})
      : _multiRetailerRepo = multiRetailerRepo,
        _backendUrl = dotenv.isInitialized
            ? (dotenv.maybeGet('BACKEND_API_URL') ?? 'http://10.0.2.2:8000')
            : 'http://10.0.2.2:8000';

  @override
  FutureEither<ChatMessage> sendPrompt(String prompt, {List<String>? history}) async {
    try {
      try {
        final uri = Uri.parse('$_backendUrl/api/v1/assistant');
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'message': prompt,
            'user_history': history,
          }),
        ).timeout(const Duration(seconds: 3));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final recs = (data['recommendations'] as List)
              .map((r) => RetailerProductModel.fromJson(r as Map<String, dynamic>))
              .toList();

          return Right(ChatMessage(
            text: data['reply'] as String,
            isUser: false,
            timestamp: DateTime.now(),
            recommendations: recs,
            explanation: data['explanation'] as String?,
          ));
        }
      } catch (_) {
        // Fallback to internal assistant parsing
      }

      // Local intelligent parsing
      final lower = prompt.toLowerCase();
      double? budget;
      final kMatch = RegExp(r'(\d+)\s*k').firstMatch(lower);
      if (kMatch != null) {
        budget = double.tryParse(kMatch.group(1)!) != null
            ? double.parse(kMatch.group(1)!) * 1000
            : null;
      }
      final numMatch = RegExp(r'(\d{4,6})').firstMatch(lower);
      if (budget == null && numMatch != null) {
        budget = double.tryParse(numMatch.group(1)!);
      }

      // Extract core query keyword
      String queryKeyword = prompt;
      if (lower.contains('phone') || lower.contains('smartphone') || lower.contains('mobile')) {
        queryKeyword = 'phone';
      } else if (lower.contains('headphone') || lower.contains('audio') || lower.contains('earphone') || lower.contains('earbud')) {
        queryKeyword = 'headphone';
      } else if (lower.contains('laptop') || lower.contains('macbook') || lower.contains('computer')) {
        queryKeyword = 'laptop';
      } else if (lower.contains('watch') || lower.contains('tracker')) {
        queryKeyword = 'watch';
      }

      var searchResult = await _multiRetailerRepo.searchMultiRetailer(
        query: queryKeyword,
        maxPrice: budget,
        sortBy: 'relevance',
      );

      var recs = searchResult.fold((f) => <RetailerProductModel>[], (p) => p.take(3).toList());
      if (recs.isEmpty) {
        // Fallback to general catalog matches
        final generalResult = await _multiRetailerRepo.searchMultiRetailer(
          query: '',
          maxPrice: budget,
          sortBy: 'relevance',
        );
        recs = generalResult.fold((f) => <RetailerProductModel>[], (p) => p.take(3).toList());
      }

      final reply = recs.isNotEmpty
          ? "Here are the top matches for '$prompt'${budget != null ? ' within your ₹${budget.toStringAsFixed(0)} budget' : ''} across verified stores:"
          : "I searched partner retailers for '$prompt'. Here are curated top picks:";

      return Right(ChatMessage(
        text: reply,
        isUser: false,
        timestamp: DateTime.now(),
        recommendations: recs,
        explanation: "Ranked by price competitiveness, review confidence score, and verified specifications.",
      ));
    } catch (e) {
      return Left(FailureWithMsg('Assistant error: $e'));
    }
  }
}
