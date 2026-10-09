// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({
    super.key,
    required this.orderId,
  });
  final String orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order confirmed!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            Text("Thank you for your purchase!",
                style: TextStyle(fontSize: 20)),
            Text("Order #$orderId",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () => context.goNamed(AppRouteName.home),
              child: Text("Continue Shopping"),
            ),
          ],
        ),
      ),
    );
  }
}
