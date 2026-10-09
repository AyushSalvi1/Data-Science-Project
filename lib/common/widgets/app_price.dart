import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/theme/app_theme.dart';

class ProductPriceText extends StatelessWidget {
  const ProductPriceText(this.price, {super.key, this.style});
  final String price;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: "Rs.",
          style: style ??
              TextTheme.of(context)
                  .titleLarge
                  ?.copyWith(color: secondarySeedColor)),
      TextSpan(
          text: price,
          style: style ??
              TextTheme.of(context)
                  .bodyLarge
                  ?.copyWith(color: secondarySeedColor))
    ]));
  }
}
