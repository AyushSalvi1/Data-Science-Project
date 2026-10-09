import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
       
            SizedBox(
              height: 200,
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 120,
                color:
                    Theme.of(context).colorScheme.primary.withAlpha(255 ~/ 0.3),
              ),
            ),
            const Gap(20),
            Text(
              "Your Cart is Empty",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Gap(16),
            Text(
              "Looks like you haven't added anything to your cart yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const Gap(8),
            Text(
              "Explore our products and discover amazing deals!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const Gap(40),
            FilledButton.icon(
              onPressed: () => context.goNamed(AppRouteName.home),
              icon: Icon(Icons.shopping_bag_outlined),
              label: Text(
                "Start Shopping",
                style: TextStyle(fontSize: 18),
              ),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
