import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_ecommerce/core/repositories/user_local_data_repository.dart';
import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/exception.dart';
import 'package:flutter_ecommerce/features/user/model/user.dart';

abstract interface class UserRepository {
  FutureEither<UserModel> getUserById({String? userId});
}

class UserRepositoryI extends UserRepository {
  final SupabaseClient _client;
  final UserLocalDataRepository _repo;
  UserRepositoryI({
    required SupabaseClient client,
    required UserLocalDataRepository repo,
  })  : _client = client,
        _repo = repo;
  @override
  FutureEither<UserModel> getUserById({String? userId}) async {
    bool isCurrentUser = userId == null; // we won't send current userId
    final failureOrCurrentUser = isCurrentUser ? await _repo.getData() : null;
    final UserModel? user =
        failureOrCurrentUser?.fold((failure) => null, (user) => user);
    return handleApplicationException(() async {
      final userMap = await _client
          .from("users")
          .select()
          .eq('id', userId ?? user!.id)
          .maybeSingle();
      final fetchUser = UserModel.fromJson(userMap!);
      isCurrentUser ? await _repo.writeData(fetchUser) : null;
      return fetchUser;
    });
  }
}
