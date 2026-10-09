import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class DontHaveAnAccount extends StatelessWidget {
  const DontHaveAnAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.goNamed(AppRouteName.signUp),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
                color:
                    ColorScheme.of(context).onSurfaceVariant.withAlpha(150))),
        TextSpan(text: "Sign up", style: TextStyle(color: Colors.blue)),
      ])),
    );
  }
}
