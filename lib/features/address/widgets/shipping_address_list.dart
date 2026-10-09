// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/address/blocs/current_shipping_address_bloc/current_shipping_address_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_ecommerce/common/widgets/shipping_address_text.dart';
import 'package:flutter_ecommerce/features/address/models/address_model.dart';
import 'package:flutter_ecommerce/routes.dart';

class ShippingAddressList extends StatelessWidget {
  const ShippingAddressList({
    super.key,
    required this.addresses,
    required this.isSelectAble,
  });
  final List<Address> addresses;
  final bool isSelectAble;

  @override
  Widget build(BuildContext context) {
    return addresses.isEmpty ? _buildNoAddressUI(context) : _buildAddressList();
  }

  /// If no address is available, show a message + add new address button
  Widget _buildNoAddressUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 80, color: Colors.grey),
          const Gap(16),
          const Text(
            "No shipping address found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Gap(16),
          FilledButton.icon(
            onPressed: () => context.pushNamed(AppRouteName.addressForm),
            icon: const Icon(Icons.add),
            label: const Text("Add Address"),
          ),
        ],
      ),
    );
  }

  /// If addresses exist, show the list of addresses
  Widget _buildAddressList() {
    String? selectedAddressId;

    return ListView.builder(
      itemCount: addresses.length,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemBuilder: (context, index) {
        final address = addresses[index];
        if (isSelectAble) {
          return BlocBuilder<CurrentShippingAddressBloc,
              CurrentShippingAddressState>(
            builder: (context, state) {
              selectedAddressId = state.maybeWhen(
                loaded: (address) => address.id,
                orElse: () => null,
              );
              return RadioListTile(
                  value: address.id,
                  groupValue: selectedAddressId,
                  onChanged: (value) {
                    selectedAddressId = value;
                    sl<CurrentShippingAddressBloc>().add(
                        CurrentShippingAddressEvent.currentShipingAddress(
                            address));
                  },
                  title: __buildAddressCard(context, address));
            },
          );
        }
        return __buildAddressCard(context, address);
      },
    );
  }

  Padding __buildAddressCard(BuildContext context, Address address) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card.filled(
        color: ColorScheme.of(context).surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: ShippingAddressText(address: address),
            trailing: const Icon(Icons.edit, size: 18),
          ),
        ),
      ),
    );
  }
}
