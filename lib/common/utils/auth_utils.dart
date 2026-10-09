import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/core/repositories/user_local_data_repository.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class AuthUtil {
  static Future<void> checkAuthAndProceed(
    BuildContext context,
    void Function() onSuccess,
  ) async {
    final repo = sl<UserLocalDataRepository>();
    final result = await repo.getData();
    result.fold(
      (_) => context.pushNamed(AppRouteName.authGuard),
      (_) => onSuccess(),
    );
  }
}
