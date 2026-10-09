// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/app/restart_widget.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_ecommerce/common/utils/toast_msg.dart';
import 'package:flutter_ecommerce/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_ecommerce/routes.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.authBloc,
  });
  final String buttonText;
  final VoidCallback onPressed;
  final AuthBloc authBloc;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        child: BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, state) => state.maybeWhen(
              loaded: (data) {
                RestartWidget.restartApp(context);
                // sl<UserLocalDataBloc>().add(UserLocalDataEvent.get());
                AppToast.success(context, data);
                context.goNamed(AppRouteName.home);
                return null;
              },
              failure: (failure) => AppToast.error(context, failure.toString()),
              orElse: () {
                return null;
              }),
          builder: (context, state) {
            return state.maybeWhen(
                loading: () => Center(child: CircularProgressIndicator()),
                orElse: () => FilledButton(
                    onPressed: onPressed, child: Text(buttonText)));
          },
        ));
  }
}
