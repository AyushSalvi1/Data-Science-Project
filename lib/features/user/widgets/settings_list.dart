import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/widgets/custom_list_tile_card.dart';
import 'package:flutter_ecommerce/common/widgets/role_access_control_widget.dart';
import 'package:flutter_ecommerce/features/wishlist/pages/wishlist_page.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.payment_outlined),
            SizedBox(width: 8),
            Text("Payment Methods"),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.money, color: Colors.green),
              title: Text("Cash on Delivery"),
              subtitle: Text("Active (Default payment mode)"),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.qr_code, color: Colors.blue),
              title: Text("UPI / Instant Transfer"),
              subtitle: Text("Google Pay, PhonePe, Paytm supported"),
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.credit_card, color: Colors.deepPurple),
              title: Text("Credit / Debit Cards"),
              subtitle: Text("Visa, MasterCard, RuPay supported"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline),
            SizedBox(width: 8),
            Text("Help & FAQs"),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "How does multi-store comparison work?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("ShopWave aggregates real-time price feeds across Amazon India, Flipkart, and Croma so you always get the lowest verified price."),
              SizedBox(height: 12),
              Text(
                "How does image search work?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("Capture or upload any product photo and our visual embedding engine finds visually similar products across catalog feeds."),
              SizedBox(height: 12),
              Text(
                "What are price drop alerts?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("Enable alerts on any product and get notified automatically as soon as any supported retailer drops the price."),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Got It"),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.support_agent_outlined),
            SizedBox(width: 8),
            Text("Customer Support"),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("We're here 24/7 to help you with your orders and shopping experience."),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email_outlined, size: 20),
                SizedBox(width: 8),
                Text("support@shopwave.ecommerce"),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 20),
                SizedBox(width: 8),
                Text("+91 1800 200 4567 (Toll Free)"),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoleBasedWidget(
          adminUser: CustomListTileCard(
            bottomMargin: 12,
            title: "Admin Dashboard",
            onTap: () => context.pushNamed(AppRouteName.admin),
          ),
        ),
        RoleBasedWidget(
          vendorUser: CustomListTileCard(
            bottomMargin: 12,
            title: "Vendor Portal",
            onTap: () => context.pushNamed(AppRouteName.vendor),
          ),
        ),
        CustomListTileCard(
          bottomMargin: 12,
          title: "My Wishlist",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WishlistPage()),
            );
          },
        ),
        CustomListTileCard(
          bottomMargin: 12,
          title: "Shipping Addresses",
          onTap: () => context.pushNamed(AppRouteName.address),
        ),
        CustomListTileCard(
          bottomMargin: 12,
          title: "Order History",
          onTap: () => context.pushNamed(AppRouteName.orders),
        ),
        CustomListTileCard(
          bottomMargin: 12,
          title: "Payment Methods",
          onTap: () => _showPaymentDialog(context),
        ),
        CustomListTileCard(
          bottomMargin: 12,
          title: "Help & FAQs",
          onTap: () => _showHelpDialog(context),
        ),
        CustomListTileCard(
          bottomMargin: 12,
          title: "Customer Support",
          onTap: () => _showSupportDialog(context),
        ),
      ],
    );
  }
}
