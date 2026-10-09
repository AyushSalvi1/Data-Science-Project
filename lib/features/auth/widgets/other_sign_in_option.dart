import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/widgets/google_logo.dart';
import 'package:gap/gap.dart';

class OtherSignInOption extends StatelessWidget {
  const OtherSignInOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          spacing: 15,
          children: [
            Expanded(child: Divider()),
            Text(
              "Or",
              style: TextTheme.of(context).labelSmall,
            ),
            Expanded(child: Divider()),
          ],
        ),
        Gap(12),
        GoogleLogo(),
      ],
    );
  }
}
