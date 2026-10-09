import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/features/auth/widgets/other_sign_in_option.dart';
import 'package:gap/gap.dart';

import 'package:flutter_ecommerce/common/utils/validator.dart';
import 'package:flutter_ecommerce/common/widgets/app_logo.dart';
import 'package:flutter_ecommerce/common/widgets/app_text_field.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_ecommerce/features/auth/widgets/already_have_an_account.dart';
import 'package:flutter_ecommerce/features/auth/widgets/auth_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthBloc _authBloc = sl<AuthBloc>();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "Create an account",
                style: TextTheme.of(context)
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Gap(8),
              Text(
                "Register with valid e-mail address.",
                style: TextTheme.of(context).bodyMedium,
              ),
              Gap(24),
              AppLogo(),
              Gap(24),
              AppTextField(
                labelText: "Name",
                hintText: "Enter your name",
                controller: _nameController,
                validator: Validators.validateName,
              ),
              Gap(16),
              AppTextField(
                labelText: "Email",
                hintText: "Enter your email",
                controller: _emailController,
                validator: Validators.validateEmail,
              ),
              Gap(16),
              AppTextField(
                controller: _passwordController,
                labelText: "Password",
                validator: Validators.validatePassword,
                obscureText: true,
                hintText: 'Enter your password',
              ),
              Gap(16),
              AuthButton(
                  authBloc: _authBloc,
                  buttonText: "Sign up",
                  onPressed: _onSignUp),
              Gap(20),
              Center(child: AlreadyHaveAnAccount()),
              OtherSignInOption()
            ],
          ),
        ),
      ),
    )));
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;

      _authBloc
          .add(AuthEvent.signUp(name: name, email: email, password: password));
    }
  }
}
