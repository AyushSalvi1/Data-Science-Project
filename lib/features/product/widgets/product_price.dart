// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/utils/extension.dart';
import 'package:flutter_ecommerce/common/widgets/app_price.dart';

import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:gap/gap.dart';

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    super.key,
    required this.product,
    this.direction = Axis.horizontal,
  });

  final Product product;
  final Axis direction;
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (product.discountPrice != null) ...[
          ProductPriceText(
            product.discountPrice!.formatPrice,
          ),
          direction == Axis.vertical ? Gap(1) : Gap(8),
          Baseline(
              baseline: 20,
              baselineType: TextBaseline.alphabetic,
              child: _buildOriginalPrice(context)),
        ] else
          ProductPriceText(
            product.price.formatPrice,
          ),
      ],
    );
  }

  Row _buildOriginalPrice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Rs.${product.price.formatPrice}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: ColorScheme.of(context).onSurfaceVariant.withAlpha(120),
                decoration: TextDecoration.lineThrough,
                decorationColor: ColorScheme.of(context).onSurfaceVariant,
              ),
        ),
        Gap(2),
        Text(
          '-${product.discountPercentage!.formatPrice}%',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: ColorScheme.of(context).onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
