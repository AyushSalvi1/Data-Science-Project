import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce/common/utils/typedef.dart';
import 'package:flutter_ecommerce/core/failure/failure.dart';
import 'package:flutter_ecommerce/features/user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class UserLocalDataRepository {
  FutureEither<UserModel> getData();
  Future<void> writeData(UserModel user);
  Future<void> deleteData();
}

class UserLocalDataRepositoryI implements UserLocalDataRepository {
  final SharedPreferences _pref;
  static const String _userKey = 'local_user_data';

  UserLocalDataRepositoryI({required SharedPreferences pref}) : _pref = pref;

  @override
  FutureEither<UserModel> getData() async {
    try {
      final String? userData = _pref.getString(_userKey);
      if (userData == null) {
        return Left(FailureWithMsg('No user data found'));
      }
      final Map<String, dynamic> jsonMap = json.decode(userData);
      return Right(UserModel.fromJson(jsonMap));
    } catch (e) {
      return Left(FailureWithMsg('Failed to retrieve user data: $e'));
    }
  }

  @override
  Future<void> writeData(UserModel user) async {
    try {
      final String jsonString = json.encode(user.toJson());
      final success = await _pref.setString(_userKey, jsonString);
      if (!success) throw 'Failed to save user data';
      return;
    } catch (e) {
      throw 'Failed to save user data: $e';
    }
  }

  @override
  Future<void> deleteData() async {
    try {
      final success = await _pref.remove(_userKey);
      if (!success) throw 'Failed to delete user data';
      return;
    } catch (e) {
      throw 'Failed to delete user data: $e';
    }
  }
}
