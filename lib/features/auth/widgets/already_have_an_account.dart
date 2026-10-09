
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  const AlreadyHaveAnAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.goNamed(AppRouteName.signIn),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
                color: ColorScheme.of(context)
                    .onSurfaceVariant
                    .withAlpha(150))),
        TextSpan(
            text: "Sign In",
            style: TextStyle(color: Colors.blue)),
      ])),
    );
  }
}
