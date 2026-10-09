import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/widgets/custom_list_tile_card.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          spacing: 12,
          children: [
            CustomListTileCard(
                title: "Add Product",
                onTap: () => context.pushNamed(AppRouteName.productForm)),
            CustomListTileCard(
                title: "Add Category",
                onTap: () => context.pushNamed(AppRouteName.categoryForm)),
            CustomListTileCard(
                title: "Manage Orders",
                onTap: () => context.pushNamed(AppRouteName.orderManagement)),

            // CustomListTileCard(
            //     title: "Manage Vendors",
            //     onTap: () => context.pushNamed(AppRouteName.vendorManagement)),
          ],
        ),
      ),
    );
  }
}
