import 'package:flutter/material.dart';

class RetailerBadge extends StatelessWidget {
  final String retailerName;

  const RetailerBadge({super.key, required this.retailerName});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    final lower = retailerName.toLowerCase();
    if (lower.contains('amazon')) {
      bg = const Color(0xFFFF9900).withAlpha(40);
      fg = const Color(0xFFD47700);
      icon = Icons.shopping_bag_outlined;
    } else if (lower.contains('flipkart')) {
      bg = const Color(0xFF2874F0).withAlpha(40);
      fg = const Color(0xFF1E5EC5);
      icon = Icons.flash_on;
    } else if (lower.contains('croma')) {
      bg = const Color(0xFF00B0B9).withAlpha(40);
      fg = const Color(0xFF00838A);
      icon = Icons.storefront;
    } else {
      bg = Theme.of(context).colorScheme.primaryContainer;
      fg = Theme.of(context).colorScheme.onPrimaryContainer;
      icon = Icons.verified;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            retailerName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
