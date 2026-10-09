import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/widgets/custom_cached_network_image.dart';
import 'package:flutter_ecommerce/features/product/widgets/product_price.dart';
import 'package:flutter_ecommerce/features/wishlist/blocs/wishlist_bloc/wishlist_bloc.dart';
import 'package:flutter_ecommerce/features/wishlist/blocs/wishlist_bloc/wishlist_state.dart';
import 'package:gap/gap.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorScheme.of(context).surfaceContainerLow,
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(12)),
                        child: AppCachedNetworkImage(
                          imageUrl: product.images.firstOrNull?.url,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: BlocBuilder<WishlistBloc, WishlistState>(
                      builder: (context, state) {
                        final isWishlisted = (state is WishlistLoadedState) &&
                            state.isWishlisted(product.id);
                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            context
                                .read<WishlistBloc>()
                                .add(ToggleWishlistEvent(product));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(200),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isWishlisted ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: isWishlisted ? Colors.red : Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(8),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.labelMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(4),
                  FittedBox(
                    child: ProductPrice(
                        direction: Axis.vertical, product: product),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
