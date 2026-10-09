import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:flutter_ecommerce/features/wishlist/blocs/wishlist_bloc/wishlist_bloc.dart';
import 'package:flutter_ecommerce/features/wishlist/blocs/wishlist_bloc/wishlist_state.dart';
import 'package:flutter_ecommerce/features/wishlist/models/wishlist_item.dart';
import 'package:flutter_ecommerce/features/wishlist/repositories/wishlist_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class MockWishlistRepository implements WishlistRepository {
  final List<WishlistItem> items = [];
  final Set<String> _wishlistedIds = {};

  @override
  FutureEither<List<WishlistItem>> getWishlist() async {
    return Right(List.unmodifiable(items));
  }

  @override
  FutureEither<bool> toggleWishlist(Product product) async {
    if (_wishlistedIds.contains(product.id)) {
      _wishlistedIds.remove(product.id);
      items.removeWhere((item) => item.productId == product.id);
      return const Right(false);
    } else {
      _wishlistedIds.add(product.id);
      items.add(WishlistItem(
        id: 'wish-${product.id}',
        userId: 'user-1',
        productId: product.id,
        createdAt: DateTime.now(),
        product: product,
      ));
      return const Right(true);
    }
  }

  @override
  bool isWishlisted(String productId) {
    return _wishlistedIds.contains(productId);
  }
}

void main() {
  group('WishlistBloc Tests', () {
    late MockWishlistRepository mockRepo;
    late WishlistBloc wishlistBloc;

    final testProduct = Product(
      id: 'prod-101',
      name: 'Noise ColorFit Pulse Grand',
      description: 'Smartwatch with 1.69 inch HD display',
      price: 1999.0,
      discountPrice: null,
      images: [],
      stockQuantity: 10,
    );

    setUp(() {
      mockRepo = MockWishlistRepository();
      wishlistBloc = WishlistBloc(repo: mockRepo);
    });

    tearDown(() {
      wishlistBloc.close();
    });

    test('Initial state is WishlistInitialState', () {
      expect(wishlistBloc.state, isA<WishlistInitialState>());
    });

    test('LoadWishlistEvent emits Loading and Loaded states', () async {
      mockRepo.items.add(WishlistItem(
        id: 'w-1',
        userId: 'u-1',
        productId: 'prod-101',
        createdAt: DateTime.now(),
        product: testProduct,
      ));
      mockRepo._wishlistedIds.add('prod-101');

      wishlistBloc.add(const LoadWishlistEvent());

      await expectLater(
        wishlistBloc.stream,
        emitsInOrder([
          isA<WishlistLoadingState>(),
          predicate<WishlistState>((state) {
            return state is WishlistLoadedState &&
                state.items.length == 1 &&
                state.wishlistedProductIds.contains('prod-101');
          }),
        ]),
      );
    });

    test('ToggleWishlistEvent adds and removes item', () async {
      wishlistBloc.add(ToggleWishlistEvent(testProduct));

      await expectLater(
        wishlistBloc.stream,
        emits(
          predicate<WishlistState>((state) {
            return state is WishlistLoadedState &&
                state.wishlistedProductIds.contains('prod-101');
          }),
        ),
      );

      // Now toggle off
      wishlistBloc.add(ToggleWishlistEvent(testProduct));

      await expectLater(
        wishlistBloc.stream,
        emits(
          predicate<WishlistState>((state) {
            return state is WishlistLoadedState &&
                !state.wishlistedProductIds.contains('prod-101');
          }),
        ),
      );
    });
  });
}
