import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/exception.dart';
import 'package:flutter_ecommerce/core/repositories/user_local_data_repository.dart';
import 'package:flutter_ecommerce/features/address/models/address_form.dart';
import 'package:flutter_ecommerce/features/address/models/address_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AddressRepository {
  FutureEither<String> addAddress(AddressForm address);
  FutureEither<List<Address>> getUserAddress();
}

class AddressRepositoryI implements AddressRepository {
  final UserLocalDataRepository _userRepo;
  final SupabaseClient _client;

  AddressRepositoryI(
      {required SupabaseClient client,
      required UserLocalDataRepository userRepo})
      : _client = client,
        _userRepo = userRepo;
  @override
  FutureEither<String> addAddress(AddressForm address) async {
    return await handleApplicationException(() async {
      await _client.from("addresses").insert({
        ...address.toJson(),
        "user_id": await _getUserId(),
      });
      return "Address added successfully";
    });
  }

  Future<String> _getUserId() async {
    final failureOrUser = await _userRepo.getData();
    return failureOrUser.fold((failure) => throw failure, (user) => user.id);
  }

  @override
  FutureEither<List<Address>> getUserAddress() async {
    return await handleApplicationException(() async {
      final userId = await _getUserId();
      final response =
          await _client.from("addresses").select().eq("user_id", userId);
      return List.from(response).map((e) => Address.fromJson(e)).toList();
    });
  }
}
