import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/widgets/app_loading.dart';
import 'package:flutter_ecommerce/features/address/blocs/get_address_bloc/get_address_bloc.dart';
import 'package:flutter_ecommerce/features/address/widgets/add_shipping_address.dart';
import 'package:flutter_ecommerce/features/address/widgets/address_card.dart';

/// A widget that resolves the shipping address by checking the state of
/// the GetAddressBloc. If there are no addresses, it shows a button to add
/// a new shipping address. If there are addresses, it displays the first
/// address in a card. If the state is loading, it shows a loading indicator.
/// If there is an error, it displays the error message.
/// This widget is used in the checkout page to ensure that the user has
/// a shipping address before proceeding with the order.
class ShippingAddressResolver extends StatelessWidget {
  const ShippingAddressResolver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAddressBloc, GetAddressState>(
      builder: (context, state) {
        return state.when(
          initial: () => SizedBox(),
          loading: () => AppLoading.center(),
          loaded: (addresses) => addresses.isEmpty
              ? AddShippingAddressButton()
              : ShippingAddressCard(
                  address: addresses.first,
                ),
          failure: (failure) => Text(failure.toString()),
        );
      },
    );
  }
}
