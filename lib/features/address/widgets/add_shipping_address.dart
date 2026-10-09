import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class AddShippingAddressButton extends StatelessWidget {
  const AddShippingAddressButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: () => context.pushNamed(AppRouteName.addressForm),
        child: Card.filled(
          color: ColorScheme.of(context).surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      "Shiping address",
                      style: TextTheme.of(context).bodySmall,
                    ),
                    Text(
                      "Add Shiping address",
                      style: TextTheme.of(context).bodyLarge,
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
