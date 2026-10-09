// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_ecommerce/common/utils/loading_dialog.dart';
import 'package:flutter_ecommerce/common/utils/toast_msg.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/address/blocs/get_address_bloc/get_address_bloc.dart';
import 'package:flutter_ecommerce/features/cart/blocs/cart_bloc/cart_bloc.dart';
import 'package:flutter_ecommerce/features/cart/blocs/get_cart_bloc/get_cart_bloc.dart';
import 'package:flutter_ecommerce/features/order/blocs/order_bloc/order_bloc.dart';
import 'package:flutter_ecommerce/features/order/models/buy_now_and_cart_order_models.dart';
import 'package:flutter_ecommerce/routes.dart';

class CheckoutBottomCartOrder extends StatefulWidget {
  const CheckoutBottomCartOrder({
    super.key,
    required this.isShippingAddressSelected,
  });
  final bool isShippingAddressSelected;

  @override
  State<CheckoutBottomCartOrder> createState() =>
      _CheckoutBottomCartOrderState();
}

class _CheckoutBottomCartOrderState extends State<CheckoutBottomCartOrder> {
  final _orderBloc = sl<OrderBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCartBloc, GetCartState>(
      builder: (context, state) {
        return state.maybeWhen(
            loaded: (data) => Container(
                  color: ColorScheme.of(context).surfaceContainerLow,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Total",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text("Rs. ${data.subTotal}")
                          ],
                        ),
                        Spacer(),
                        BlocListener<OrderBloc, OrderState>(
                          bloc: _orderBloc,
                          listener: (context, state) {
                            state.whenOrNull(
                                loading: () =>
                                    AppProgressIndicator.show(context),
                                failure: (failure) {
                                  AppProgressIndicator.hide(context);
                                  AppToast.error(context, failure.toString());
                                },
                                loaded: (order) {
                                  AppProgressIndicator.hide(context);
                                  sl<CartBloc>().add(CartEvent.deleteCarts(
                                      data.selectedCarts));
                                  return context.pushReplacementNamed(
                                      AppRouteName.orderSuccessPage,
                                      extra: order);
                                });
                          },
                          child: BlocBuilder<GetAddressBloc, GetAddressState>(
                            builder: (context, state) {
                              return FilledButton(
                                onPressed: !widget.isShippingAddressSelected
                                    ? null
                                    : () {
                                        _placeCartOrder(CartOrderModel(
                                          carts: data.selectedCarts,
                                          totalAmount: data.subTotal,
                                        ));
                                      },
                                child: Text("Place order"),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            orElse: () => SizedBox());
      },
    );
  }

  void _placeCartOrder(CartOrderModel order) {
    _orderBloc.add(OrderEvent.placeCartOrder(order));
  }
}
