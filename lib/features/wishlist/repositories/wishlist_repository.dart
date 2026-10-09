import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/failure/failure.dart';
import 'package:flutter_ecommerce/core/services/offline_cache_service.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:flutter_ecommerce/features/user/repositories/user_repository.dart';
import 'package:flutter_ecommerce/features/wishlist/models/wishlist_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class WishlistRepository {
  FutureEither<List<WishlistItem>> getWishlist();
  FutureEither<bool> toggleWishlist(Product product);
  bool isWishlisted(String productId);
}

class WishlistRepositoryI implements WishlistRepository {
  final SupabaseClient _client;
  final OfflineCacheService _cacheService;
  final UserRepository _userRepo;

  WishlistRepositoryI({
    required SupabaseClient client,
    required OfflineCacheService cacheService,
    required UserRepository userRepo,
  })  : _client = client,
        _cacheService = cacheService,
        _userRepo = userRepo;

  @override
  bool isWishlisted(String productId) {
    return _cacheService.isProductWishlisted(productId);
  }

  @override
  FutureEither<List<WishlistItem>> getWishlist() async {
    try {
      final userResult = await _userRepo.getUserById();
      final user = userResult.fold((f) => null, (u) => u);

      if (user != null) {
        try {
          final response = await _client
              .from('wishlists')
              .select('id, user_id, product_id, created_at, products(*, product_images(*))')
              .eq('user_id', user.id);

          final items = (response as List).map((row) {
            final prodData = row['products'];
            Product? prod;
            if (prodData != null) {
              prod = Product.fromJson(prodData as Map<String, dynamic>);
            }
            return WishlistItem(
              id: row['id'] as String,
              userId: row['user_id'] as String,
              productId: row['product_id'] as String,
              product: prod,
              createdAt: DateTime.tryParse(row['created_at'].toString()) ?? DateTime.now(),
            );
          }).toList();

          // Sync with offline cache
          final ids = items.map((i) => i.productId).toList();
          await _cacheService.cacheWishlistIds(ids);

          return Right(items);
        } catch (_) {
          // If network / Supabase fails, fallback gracefully to offline cache
        }
      }

      // Offline fallback: reconstruct wishlist items from cached products
      final cachedIds = _cacheService.getCachedWishlistIds();
      final cachedProducts = _cacheService.getCachedProducts();
      final items = cachedIds.map((id) {
        final prod = cachedProducts.cast<Product?>().firstWhere(
              (p) => p?.id == id,
              orElse: () => null,
            );
        return WishlistItem(
          id: id,
          userId: user?.id ?? 'guest',
          productId: id,
          product: prod,
          createdAt: DateTime.now(),
        );
      }).toList();

      return Right(items);
    } catch (e) {
      return Left(FailureWithMsg('Error fetching wishlist: $e'));
    }
  }

  @override
  FutureEither<bool> toggleWishlist(Product product) async {
    try {
      await _cacheService.toggleWishlistId(product.id);
      final isNowWishlisted = _cacheService.isProductWishlisted(product.id);

      final userResult = await _userRepo.getUserById();
      final user = userResult.fold((f) => null, (u) => u);

      if (user != null) {
        try {
          if (isNowWishlisted) {
            await _client.from('wishlists').upsert({
              'user_id': user.id,
              'product_id': product.id,
            });
          } else {
            await _client
                .from('wishlists')
                .delete()
                .match({'user_id': user.id, 'product_id': product.id});
          }
        } catch (_) {
          // Keep offline state even if backend network call throws
        }
      }

      return Right(isNowWishlisted);
    } catch (e) {
      return Left(FailureWithMsg('Failed to update wishlist: $e'));
    }
  }
}
