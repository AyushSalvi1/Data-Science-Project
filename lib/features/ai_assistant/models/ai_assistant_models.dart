import 'package:flutter_ecommerce/features/multi_retailer/models/retailer_product.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<RetailerProductModel> recommendations;
  final String? explanation;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.recommendations = const [],
    this.explanation,
  });
}
