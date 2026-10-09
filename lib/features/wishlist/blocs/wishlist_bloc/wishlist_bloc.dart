import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/wishlist/blocs/wishlist_bloc/wishlist_state.dart';
import 'package:flutter_ecommerce/features/wishlist/repositories/wishlist_repository.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _repo;

  WishlistBloc({required WishlistRepository repo})
      : _repo = repo,
        super(const WishlistInitialState()) {
    on<LoadWishlistEvent>(_onLoadWishlist);
    on<ToggleWishlistEvent>(_onToggleWishlist);
  }

  Future<void> _onLoadWishlist(
    LoadWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(const WishlistLoadingState());
    final result = await _repo.getWishlist();
    result.fold(
      (failure) => emit(WishlistErrorState(failure.toString())),
      (items) {
        final ids = items.map((i) => i.productId).toSet();
        emit(WishlistLoadedState(items: items, wishlistedProductIds: ids));
      },
    );
  }

  Future<void> _onToggleWishlist(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    final prevWishlisted = _repo.isWishlisted(event.product.id);
    final currentItems = (state is WishlistLoadedState)
        ? (state as WishlistLoadedState).items
        : [];
    final currentIds = (state is WishlistLoadedState)
        ? Set<String>.from((state as WishlistLoadedState).wishlistedProductIds)
        : <String>{};

    // Optimistically update
    if (prevWishlisted) {
      currentIds.remove(event.product.id);
    } else {
      currentIds.add(event.product.id);
    }

    emit(WishlistLoadedState(
      items: currentItems.cast(),
      wishlistedProductIds: currentIds,
    ));

    final result = await _repo.toggleWishlist(event.product);
    result.fold(
      (failure) => null, // preserve optimistic state
      (_) => add(const LoadWishlistEvent()),
    );
  }
}
