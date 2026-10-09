import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/features/auth/widgets/dont_have_an_account.dart';
import 'package:flutter_ecommerce/features/auth/widgets/other_sign_in_option.dart';
import 'package:gap/gap.dart';

import 'package:flutter_ecommerce/common/utils/validator.dart';
import 'package:flutter_ecommerce/common/widgets/app_logo.dart';
import 'package:flutter_ecommerce/common/widgets/app_text_field.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_ecommerce/features/auth/widgets/auth_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthBloc _authBloc = sl<AuthBloc>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(48),
                  Text(
                    "Hi,\nWelcome back!",
                    style: TextTheme.of(context)
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Gap(8),
                  Text(
                    "Please login with password.",
                    style: TextTheme.of(context).bodyMedium,
                  ),
                  Gap(24),
                  AppLogo(),
                  Gap(24),
                  AppTextField(
                    labelText: "Email",
                    hintText: "Enter your email",
                    controller: _emailController,
                    validator: Validators.validateEmail,
                  ),
                  Gap(16),
                  AppTextField(
                    labelText: "Password",
                    validator: Validators.validatePassword,
                    obscureText: true,
                    hintText: 'Enter your password',
                    controller: _passwordController,
                  ),
                  Gap(16),
                  AuthButton(
                    authBloc: _authBloc,
                    buttonText: "Sign In", onPressed: _onSignIn),
                  Gap(20),
                  Center(child: DontHaveAnAccount()),
                  OtherSignInOption()
                ],
              ),
            ),
          ),
        )));
  }

  void _onSignIn() {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String password = _passwordController.text;

      _authBloc.add(AuthEvent.signIn(email: email, password: password));
    }
  }
}
