import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/widgets/app_loading.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/cart/blocs/get_cart_bloc/get_cart_bloc.dart';
import 'package:flutter_ecommerce/features/cart/models/cart.dart';
import 'package:flutter_ecommerce/features/cart/widgets/cart_card.dart';
import 'package:flutter_ecommerce/features/cart/widgets/empty_cart.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shopping Cart",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<GetCartBloc, GetCartState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox(),
            loading: () => AppLoading.center(),
            loaded: (data) => CustomScrollView(
              slivers: [
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: _BuildCarts(
                    carts: data.carts,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: const Duration(milliseconds: 300)),
            failure: (failure) => Center(
              child: Text(
                failure.toString(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).toInt()),
              blurRadius: 10,
              offset: const Offset(0, -3),
              spreadRadius: 1,
            ),
          ],
        ),
        child: _BottomSheet(),
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCartBloc, GetCartState>(
      builder: (context, state) {
        return state.maybeWhen(
            loaded: (data) => data.carts.isEmpty
                ? EmptyCartWidget()
                : Container(
                    color: ColorScheme.of(context).surfaceContainerLow,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            children: [
                              // Select all checkbox
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: data.isAllCartSelected,
                                    onChanged: (value) => sl<GetCartBloc>()
                                        .add(GetCartEvent.selectAllCarts()),
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  Text(
                                    "Select All",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Spacer(),
                              // Subtotal
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Subtotal",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                  Text(
                                    "Rs. ${data.subTotal.toStringAsFixed(2)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                ],
                              ),
                              Gap(16),
                              // Checkout button
                              FilledButton.icon(
                                onPressed: data.selectedCarts.isEmpty
                                    ? null
                                    : () => context
                                        .pushNamed(AppRouteName.checkout),
                                icon: Icon(Icons.shopping_cart_checkout),
                                label: Text("Checkout"),
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideX(duration: 200.ms),
            orElse: () => SizedBox());
      },
    );
  }
}

class _BuildCarts extends StatelessWidget {
  final List<Cart> carts;
  const _BuildCarts({
    required this.carts,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: carts.length,
      itemBuilder: (context, index) {
        final cart = carts[index];
        return CartCard(cart: cart)
            .animate(delay: Duration(milliseconds: 50 * index))
            .fadeIn(duration: const Duration(milliseconds: 300))
            .slideX(
                begin: 0.1,
                end: 0,
                duration: const Duration(milliseconds: 300));
      },
    );
  }
}
