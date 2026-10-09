import 'dart:math';
import 'package:flutter_ecommerce/core/repositories/user_local_data_repository.dart';
import 'package:flutter_ecommerce/core/exception.dart';
import 'package:flutter_ecommerce/features/user/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_ecommerce/common/utils/typedef.dart';

abstract interface class AuthRepository {
  FutureEither<String> signUp(
      {required String name, required String password, required String email});

  FutureEither<String> signIn(
      {required String password, required String email});

  FutureEither<String> signOut();
}

class AuthRepositoryI implements AuthRepository {
  final SupabaseClient _client;
  final UserLocalDataRepository _repo;
  AuthRepositoryI(
      {required SupabaseClient client, required UserLocalDataRepository repo})
      : _repo = repo,
        _client = client;

  @override
  FutureEither<String> signUp(
      {required String name,
      required String password,
      required String email}) async {
    return await handleApplicationException(() async {
      final response = await _client.auth
          .signUp(email: email, password: password, data: {'name': name});
      final username =
          "${name.split(" ").first}${Random().nextInt(99999999)}".toLowerCase();
      await _client.from('users').insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'username': username,
      });
      await _repo.writeData(UserModel(
          id: response.user!.id,
          role: "general",
          name: name,
          username: username,
          email: email));
      return "User registered successfully";
    });
  }

  @override
  FutureEither<String> signIn(
      {required String password, required String email}) async {
    return await handleApplicationException(() async {
      final response = await _client.auth
          .signInWithPassword(email: email, password: password);
      await _repo.writeData(UserModel(
          name: "",
          id: response.user!.id,
          role: "general",
          username: "",
          email: email));
      return "User logged in successfully";
    });
  }

  @override
  FutureEither<String> signOut() async {
    return await handleApplicationException(() async {
      await _client.auth.signOut();
      await _repo.deleteData();

      return "User logged out successfully";
    });
  }
}
