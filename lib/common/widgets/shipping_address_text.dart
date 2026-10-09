import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/features/address/models/address_model.dart';

class ShippingAddressText extends StatelessWidget {
  const ShippingAddressText({
    super.key,
    required this.address,
  });

  final Address address;

  @override
  Widget build(BuildContext context) {
    return RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
            style: TextTheme.of(context).bodyLarge,
            children: [
              TextSpan(
                text: address.address,
              ),
              TextSpan(
                text: " ${address.state} ",
              ),
              TextSpan(
                text: "${address.city} ",
              ),
              TextSpan(
                text: address.zipCode ?? "",
              ),
            ]));
  }
}
