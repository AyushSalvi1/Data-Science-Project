import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/widgets/app_loading.dart';
import 'package:flutter_ecommerce/features/address/blocs/current_shipping_address_bloc/current_shipping_address_bloc.dart';
import 'package:flutter_ecommerce/features/address/widgets/shiping_address_resolver.dart';
import 'package:flutter_ecommerce/features/cart/blocs/get_cart_bloc/get_cart_bloc.dart';
import 'package:flutter_ecommerce/features/cart/models/cart.dart';
import 'package:flutter_ecommerce/features/order/models/buy_now_and_cart_order_models.dart';
import 'package:flutter_ecommerce/features/order/widgets/checkout_bottom_buy_now_order.dart';
import 'package:flutter_ecommerce/features/order/widgets/checkout_bottom_cart_order.dart';
import 'package:flutter_ecommerce/features/order/widgets/checkout_product_cart.dart';
import 'package:gap/gap.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({
    super.key,
    this.order,
  });
  final BuyNowOrderModel? order;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Checkout"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              ShippingAddressResolver(),
              Gap(24),
              Expanded(
                child: BlocBuilder<GetCartBloc, GetCartState>(
                  builder: (context, state) {
                    return state.when(
                        initial: () => SizedBox(),
                        loading: () => AppLoading.center(),
                        loaded: (data) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: order != null
                                  ? CheckoutProductCart(
                                      product: order!.product,
                                      quantity: order!.quantity,
                                    )
                                  : _BuildCheckOutCarts(
                                      selectedCarts: data.selectedCarts,
                                    ),
                            ),
                        failure: (failure) => Center(
                              child: Text(failure.toString()),
                            ));
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: BlocBuilder<CurrentShippingAddressBloc,
              CurrentShippingAddressState>(
            builder: (context, state) {
              bool isShippingAddressSelected = state.maybeWhen(
                  loaded: (address) => true, orElse: () => false);
              return order == null
                  ? CheckoutBottomCartOrder(
                      isShippingAddressSelected: isShippingAddressSelected)
                  : CheckoutBottomBuyNowOrder(
                      order: order!,
                      isShippingAddressSelected: isShippingAddressSelected,
                    );
            },
          ),
        ));
  }
}

class _BuildCheckOutCarts extends StatelessWidget {
  const _BuildCheckOutCarts({required this.selectedCarts});
  final List<Cart> selectedCarts;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: selectedCarts.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final cart = selectedCarts[index];
          return CheckoutProductCart(
            product: cart.product,
            quantity: cart.quantity,
          );
        });
  }
}
