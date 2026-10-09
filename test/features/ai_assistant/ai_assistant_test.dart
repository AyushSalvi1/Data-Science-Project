import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/features/ai_assistant/repositories/ai_assistant_repository.dart';
import 'package:flutter_ecommerce/features/multi_retailer/repositories/multi_retailer_repository.dart';

void main() {
  group('AIAssistantRepository Tests', () {
    test('Correctly extracts budget constraint from natural language (e.g., 20k)', () async {
      final multiRepo = MultiRetailerRepositoryI();
      final assistantRepo = AIAssistantRepositoryI(multiRetailerRepo: multiRepo);

      final result = await assistantRepo.sendPrompt('Best smartphone under 20k with good camera');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Assistant prompt should succeed'),
        (message) {
          expect(message.isUser, isFalse);
          expect(message.text, contains('20000'));
          expect(message.recommendations, isNotEmpty);
          for (final rec in message.recommendations) {
            expect(rec.price, lessThanOrEqualTo(20000.0));
          }
        },
      );
    });

    test('Answers generic product queries with recommendations and explanation', () async {
      final multiRepo = MultiRetailerRepositoryI();
      final assistantRepo = AIAssistantRepositoryI(multiRetailerRepo: multiRepo);

      final result = await assistantRepo.sendPrompt('Show me premium noise cancelling headphones');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Assistant prompt should succeed'),
        (message) {
          expect(message.recommendations.isNotEmpty, isTrue);
          expect(message.explanation, isNotNull);
          expect(message.explanation!.isNotEmpty, isTrue);
        },
      );
    });
  });
}
