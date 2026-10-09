import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/core/services/offline_cache_service.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OfflineCacheService Tests', () {
    late OfflineCacheService cacheService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      cacheService = OfflineCacheService(pref: prefs);
    });

    test('Caches and retrieves products', () async {
      final products = [
        const Product(
          id: 'p-1',
          name: 'Mechanical Keyboard',
          description: 'RGB Backlit Mechanical Gaming Keyboard',
          price: 3499.0,
          discountPrice: null,
          images: [],
          stockQuantity: 10,
        ),
      ];

      await cacheService.cacheProducts(products);
      final cached = cacheService.getCachedProducts();

      expect(cached.length, 1);
      expect(cached.first.id, 'p-1');
      expect(cached.first.name, 'Mechanical Keyboard');
      expect(cached.first.price, 3499.0);
    });

    test('Caches and manages wishlist IDs', () async {
      await cacheService.cacheWishlistIds(['id-1', 'id-2']);
      expect(cacheService.getCachedWishlistIds(), ['id-1', 'id-2']);
      expect(cacheService.isProductWishlisted('id-1'), isTrue);
      expect(cacheService.isProductWishlisted('id-3'), isFalse);

      await cacheService.toggleWishlistId('id-1');
      expect(cacheService.isProductWishlisted('id-1'), isFalse);

      await cacheService.toggleWishlistId('id-3');
      expect(cacheService.isProductWishlisted('id-3'), isTrue);
    });

    test('Caches and retrieves user preferences', () async {
      final prefs = {
        'budget': 35000.0,
        'preferredRetailers': ['Amazon India', 'Croma'],
        'priceDropAlerts': true,
      };

      await cacheService.saveUserPreferences(prefs);
      final retrieved = cacheService.getUserPreferences();

      expect(retrieved['budget'], 35000.0);
      expect(retrieved['preferredRetailers'], ['Amazon India', 'Croma']);
      expect(retrieved['priceDropAlerts'], isTrue);
    });

    test('Records and limits search history', () async {
      await cacheService.addSearchQuery('laptop');
      await cacheService.addSearchQuery('headphones');
      await cacheService.addSearchQuery('smartphone');

      final history = cacheService.getSearchHistory();
      expect(history.first, 'smartphone');
      expect(history.length, 3);
    });
  });
}
