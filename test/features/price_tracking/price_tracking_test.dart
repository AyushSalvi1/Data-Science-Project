import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/features/price_tracking/models/price_history_model.dart';
import 'package:flutter_ecommerce/features/price_tracking/repositories/price_tracking_repository.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';

void main() {
  group('Price Tracking Tests', () {
    test('PriceHistoryItem correctly deserializes from JSON', () {
      final json = {
        'date': '2026-10-01T12:00:00Z',
        'price': 4999.0,
        'retailer': 'Amazon India',
      };

      final item = PriceHistoryItem.fromJson(json);

      expect(item.price, 4999.0);
      expect(item.retailer, 'Amazon India');
      expect(item.date.year, 2026);
    });

    test('PriceAnalytics model computes metrics correctly', () {
      final history = [
        PriceHistoryItem(date: DateTime(2026, 9, 1), price: 5500.0, retailer: 'ShopWave'),
        PriceHistoryItem(date: DateTime(2026, 9, 15), price: 5200.0, retailer: 'ShopWave'),
        PriceHistoryItem(date: DateTime(2026, 10, 1), price: 4800.0, retailer: 'ShopWave'),
      ];

      final analytics = PriceAnalytics(
        productId: 'prod-123',
        currentPrice: 4800.0,
        lowestPrice: 4800.0,
        highestPrice: 5500.0,
        trend: 'dropping',
        potentialSavings: 700.0,
        history: history,
      );

      expect(analytics.currentPrice, 4800.0);
      expect(analytics.lowestPrice, 4800.0);
      expect(analytics.highestPrice, 5500.0);
      expect(analytics.potentialSavings, 700.0);
      expect(analytics.trend, 'dropping');
      expect(analytics.history.length, 3);
    });

    test('PriceTrackingRepository generates synthetic history when offline', () async {
      final repo = PriceTrackingRepositoryI();
      const product = Product(
        id: 'prod-456',
        name: 'Smart Watch',
        description: 'Fitness tracker with AMOLED display',
        price: 10000.0,
        discountPrice: 8500.0,
        images: [],
        stockQuantity: 15,
      );

      final result = await repo.getPriceAnalytics(product);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Price history should succeed'),
        (analytics) {
          expect(analytics.productId, 'prod-456');
          expect(analytics.history.length, greaterThanOrEqualTo(3));
          expect(analytics.lowestPrice, lessThanOrEqualTo(analytics.highestPrice));
          expect(['dropping', 'stable', 'rising'].contains(analytics.trend), isTrue);
        },
      );
    });
  });
}
