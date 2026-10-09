import 'dart:convert';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:flutter_ecommerce/features/category/models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineCacheService {
  final SharedPreferences _pref;

  static const String _productsKey = 'offline_cached_products';
  static const String _categoriesKey = 'offline_cached_categories';
  static const String _wishlistKey = 'offline_cached_wishlist_ids';
  static const String _searchHistoryKey = 'offline_search_history';
  static const String _userPrefsKey = 'offline_user_preferences';

  OfflineCacheService({required SharedPreferences pref}) : _pref = pref;

  // Products Caching
  Future<void> cacheProducts(List<Product> products) async {
    try {
      final jsonList = products.map((p) => p.toJson()).toList();
      await _pref.setString(_productsKey, json.encode(jsonList));
    } catch (_) {}
  }

  List<Product> getCachedProducts() {
    try {
      final raw = _pref.getString(_productsKey);
      if (raw == null) return [];
      final List<dynamic> jsonList = json.decode(raw);
      return jsonList.map((j) => Product.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  // Categories Caching
  Future<void> cacheCategories(List<Category> categories) async {
    try {
      final jsonList = categories.map((c) => c.toJson()).toList();
      await _pref.setString(_categoriesKey, json.encode(jsonList));
    } catch (_) {}
  }

  List<Category> getCachedCategories() {
    try {
      final raw = _pref.getString(_categoriesKey);
      if (raw == null) return [];
      final List<dynamic> jsonList = json.decode(raw);
      return jsonList.map((j) => Category.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  // Wishlist Caching
  Future<void> cacheWishlistIds(List<String> productIds) async {
    await _pref.setStringList(_wishlistKey, productIds);
  }

  List<String> getCachedWishlistIds() {
    return _pref.getStringList(_wishlistKey) ?? [];
  }

  Future<void> toggleWishlistId(String productId) async {
    final ids = getCachedWishlistIds().toList();
    if (ids.contains(productId)) {
      ids.remove(productId);
    } else {
      ids.add(productId);
    }
    await cacheWishlistIds(ids);
  }

  bool isProductWishlisted(String productId) {
    return getCachedWishlistIds().contains(productId);
  }

  // Search History
  List<String> getSearchHistory() {
    return _pref.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> addSearchQuery(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) return;
    final list = getSearchHistory().toList();
    list.remove(clean);
    list.insert(0, clean);
    if (list.length > 10) list.removeLast();
    await _pref.setStringList(_searchHistoryKey, list);
  }

  // User Preferences
  Map<String, dynamic> getUserPreferences() {
    final raw = _pref.getString(_userPrefsKey);
    if (raw == null) {
      return {
        'budget': 50000.0,
        'preferredRetailers': ['Amazon India', 'Flipkart', 'Croma', 'ShopWave'],
        'categories': ['Electronics', 'Computers', 'Audio'],
        'priceDropAlerts': true,
      };
    }
    try {
      return json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<void> saveUserPreferences(Map<String, dynamic> prefs) async {
    await _pref.setString(_userPrefsKey, json.encode(prefs));
  }
}
