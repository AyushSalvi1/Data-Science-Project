import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:flutter_ecommerce/features/wishlist/models/wishlist_item.dart';

abstract class WishlistEvent {
  const WishlistEvent();
}

class LoadWishlistEvent extends WishlistEvent {
  const LoadWishlistEvent();
}

class ToggleWishlistEvent extends WishlistEvent {
  final Product product;
  const ToggleWishlistEvent(this.product);
}

// States
abstract class WishlistState {
  const WishlistState();
}

class WishlistInitialState extends WishlistState {
  const WishlistInitialState();
}

class WishlistLoadingState extends WishlistState {
  const WishlistLoadingState();
}

class WishlistLoadedState extends WishlistState {
  final List<WishlistItem> items;
  final Set<String> wishlistedProductIds;

  const WishlistLoadedState({
    required this.items,
    required this.wishlistedProductIds,
  });

  bool isWishlisted(String productId) => wishlistedProductIds.contains(productId);
}

class WishlistErrorState extends WishlistState {
  final String message;
  const WishlistErrorState(this.message);
}
