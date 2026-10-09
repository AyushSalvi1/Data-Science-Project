import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/widgets/custom_list_tile_card.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class VendorPage extends StatelessWidget {
  const VendorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Vendor Page"),
        ),
        body: ListView(
          children: [
            CustomListTileCard(
                title: "Add Product",
                onTap: () => context.pushNamed(AppRouteName.addressForm)),
            CustomListTileCard(
                title: "Manage Orders",
                onTap: () => context.pushNamed(AppRouteName.orderManagement)),
          ],
        ));
  }
}
