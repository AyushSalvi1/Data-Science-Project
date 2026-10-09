import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/exception.dart';
import 'package:flutter_ecommerce/core/repositories/user_local_data_repository.dart';
import 'package:flutter_ecommerce/features/cart/models/cart.dart';
import 'package:flutter_ecommerce/features/cart/models/cart_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

abstract interface class CartRepository {
  FutureEither<List<Cart>> getCart();
  FutureEither<String> addCart(CartForm cart);
  FutureEither<String> deleteCarts(List<Cart> carts);
  FutureEither<String> updateCart(
      {required String id, required int updatedTotalQuantity});
}

class CartRepositoryI implements CartRepository {
  final UserLocalDataRepository _userRepo;
  final SupabaseClient _client;

  CartRepositoryI(
      {required UserLocalDataRepository userRepo,
      required SupabaseClient client})
      : _userRepo = userRepo,
        _client = client;
  @override
  FutureEither<String> addCart(CartForm cart) async {
    return await handleApplicationException(() async {
      final userId = await _getUserId();
      final existingCartItem = await _client
          .from('carts')
          .select()
          .eq('user_id', userId)
          .eq('product_id', cart.productId)
          .maybeSingle();

      if (existingCartItem != null) {
        await _client.from('carts').update({
          'quantity': existingCartItem['quantity'] + cart.quantity,
        }).eq('id', existingCartItem['id']);
      } else {
        await _client
            .from('carts')
            .insert({...cart.toJson(), 'user_id': userId});
      }
      return "Success! Cart added.";
    });
  }

  @override
  FutureEither<String> updateCart(
      {required String id, required int updatedTotalQuantity}) async {
    return await handleApplicationException(() async {
      await _client
          .from("carts")
          .update({'quantity': updatedTotalQuantity}).eq('id', id);
      return "Success! Cart update.";
    });
  }

  Future<String> _getUserId() async {
    final failureOrUser = await _userRepo.getData();
    return failureOrUser.fold((failure) => throw failure, (user) => user.id);
  }

  @override
  FutureEither<List<Cart>> getCart() async {
    return await handleApplicationException(() async {
      final userId = await _getUserId();
      final cartMap = await _client
          .from('carts')
          .select('*, product:products(*,images: product_images(*))')
          .eq('user_id', userId);
      Logger().d(cartMap);

      final carts = List.from(cartMap).map((e) => Cart.fromJson(e)).toList();
      return carts;
    });
  }

  @override
  FutureEither<String> deleteCarts(List<Cart> carts) async {
    return await handleApplicationException(() async {
      final cartIds = carts.map((cart) => cart.id).toList();
      final userId = await _getUserId();
      await _client
          .from('carts')
          .delete()
          .inFilter('id', cartIds)
          .eq('user_id', userId);

      return "Success! ${carts.length} cart items deleted.";
    });
  }
}
