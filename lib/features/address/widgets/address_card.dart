import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/widgets/custom_list_tile_card.dart';

import 'package:flutter_ecommerce/common/widgets/shipping_address_text.dart';
import 'package:flutter_ecommerce/features/address/blocs/current_shipping_address_bloc/current_shipping_address_bloc.dart';
import 'package:flutter_ecommerce/features/address/models/address_model.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class ShippingAddressCard extends StatefulWidget {
  const ShippingAddressCard({
    super.key, required this.address,
  });
  final Address address;

  @override
  State<ShippingAddressCard> createState() => _ShippingAddressCardState();
}

class _ShippingAddressCardState extends State<ShippingAddressCard> {
  @override
  initState() {
    super.initState();
    context.read<CurrentShippingAddressBloc>().add(
          CurrentShippingAddressEvent.initializeShippingAddress(widget.address),
        );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentShippingAddressBloc, CurrentShippingAddressState>(
      builder: (context, state) {
        return state.maybeWhen(
            loaded: (address) => _buildAddressCard(context, address),
            orElse: () => CustomListTileCard(
                  title: "Select shipping address",
                  onTap: () =>
                      context.pushNamed(AppRouteName.address, extra: true),
                ));
      },
    );
  }

  Card _buildAddressCard(BuildContext context, Address address) {
    return Card.filled(
      color: ColorScheme.of(context).surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shiping address",
                    style: TextTheme.of(context).titleMedium,
                  ),
                  ShippingAddressText(address: address),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  ///extra true means we addresses are selectable
                  context.pushNamed(AppRouteName.address, extra: true);
                },
                icon: Icon(Icons.arrow_forward_ios_rounded))
          ],
        ),
      ),
    );
  }
}
