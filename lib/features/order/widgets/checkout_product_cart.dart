// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ecommerce/common/widgets/custom_cached_network_image.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';

class CheckoutProductCart extends StatelessWidget {
  const CheckoutProductCart({
    super.key,
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 150,
        width: 100,
        child: AppCachedNetworkImage(
          imageUrl: product.images.firstOrNull?.url,
          fit: BoxFit.cover,
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.discountPrice == null
                        ? "Rs. ${product.price}"
                        : "Rs. ${product.discountPrice}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "x$quantity",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ]);
  }
}
