import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductRedirectButton extends StatelessWidget {
  final String url;
  final String retailerName;
  final bool isCompact;

  const ProductRedirectButton({
    super.key,
    required this.url,
    required this.retailerName,
    this.isCompact = false,
  });

  Future<void> _launchProductUrl(BuildContext context) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Direct merchant link not available.")),
      );
      return;
    }

    try {
      final uri = Uri.parse(url);
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open $retailerName: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return TextButton.icon(
        onPressed: () => _launchProductUrl(context),
        icon: const Icon(Icons.open_in_new, size: 14),
        label: Text("Buy on $retailerName"),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: () => _launchProductUrl(context),
      icon: const Icon(Icons.launch, size: 16),
      label: Text("View Offer on $retailerName"),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
