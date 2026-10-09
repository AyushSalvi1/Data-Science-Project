import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/features/multi_retailer/models/retailer_product.dart';
import 'package:flutter_ecommerce/features/multi_retailer/repositories/multi_retailer_repository.dart';

void main() {
  group('MultiRetailerProductModel Tests', () {
    test('JSON serialization and deserialization preserves all fields', () {
      final json = {
        'id': 'test-123',
        'title': 'Sony WH-1000XM5 Wireless Headphones',
        'description': 'Industry leading noise cancelling headphones',
        'brand': 'Sony',
        'category': 'Electronics',
        'price': 26990.0,
        'original_price': 34990.0,
        'discount_percentage': 22.8,
        'rating': 4.6,
        'review_count': 12450,
        'image_urls': ['https://images.amazon.com/sony.jpg'],
        'retailer': {
          'name': 'Amazon India',
          'direct_url': 'https://www.amazon.in/dp/B09XS7JWHH',
          'in_stock': true,
        },
        'product_url': 'https://www.amazon.in/dp/B09XS7JWHH',
        'visual_tags': ['headphones', 'anc'],
      };

      final product = RetailerProductModel.fromJson(json);

      expect(product.id, 'test-123');
      expect(product.title, 'Sony WH-1000XM5 Wireless Headphones');
      expect(product.price, 26990.0);
      expect(product.originalPrice, 34990.0);
      expect(product.retailer.name, 'Amazon India');
      expect(product.rating, 4.6);
      expect(product.reviewCount, 12450);
      expect(product.visualTags, contains('anc'));
      expect(product.retailer.inStock, isTrue);

      final serialized = product.toJson();
      expect(serialized['id'], 'test-123');
      expect(serialized['retailer']['name'], 'Amazon India');
    });

    test('MultiRetailerRepository offline fallback filters by price and query', () async {
      final repo = MultiRetailerRepositoryI();

      final searchAll = await repo.searchMultiRetailer(query: 'phone');
      expect(searchAll.isRight(), isTrue);

      searchAll.fold(
        (failure) => fail('Search should succeed'),
        (products) {
          expect(products.isNotEmpty, isTrue);
          for (final p in products) {
            expect(
              p.title.toLowerCase().contains('phone') ||
                  p.title.toLowerCase().contains('iphone') ||
                  p.title.toLowerCase().contains('galaxy') ||
                  p.title.toLowerCase().contains('redmi') ||
                  p.title.toLowerCase().contains('oneplus'),
              isTrue,
            );
          }
        },
      );

      final searchBudget = await repo.searchMultiRetailer(
        query: 'phone',
        maxPrice: 20000.0,
      );
      searchBudget.fold(
        (failure) => fail('Budget search should succeed'),
        (products) {
          for (final p in products) {
            expect(p.price, lessThanOrEqualTo(20000.0));
          }
        },
      );
    });

    test('MultiRetailerRepository comparison generates comparison matrix', () async {
      final repo = MultiRetailerRepositoryI();

      final compResult = await repo.compareProducts(productTitle: 'iPhone 15');
      expect(compResult.isRight(), isTrue);

      compResult.fold(
        (failure) => fail('Comparison should succeed'),
        (comparison) {
          expect(comparison.productTitle, 'iPhone 15');
          expect(comparison.top3Overall.isNotEmpty, isTrue);
          expect(comparison.bestOffersByRetailer.isNotEmpty, isTrue);
          expect(comparison.verdict.isNotEmpty, isTrue);
        },
      );
    });
  });
}
