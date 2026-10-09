
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:flutter_ecommerce/features/product/widgets/product_card.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class BuildProductGrid extends StatelessWidget {
  const BuildProductGrid({
    super.key,
    required this.products,
  });
  final List<Product> products;
  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () => context.pushNamed(AppRouteName.productDetailPage,
                pathParameters: {'id': products[index].id},
                extra: products[index]),
            child: ProductCard(product: products[index]));
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 250,
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8),
    );
  }
}




