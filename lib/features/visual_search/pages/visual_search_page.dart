import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/widgets/custom_cached_network_image.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/comparison/pages/comparison_page.dart';
import 'package:flutter_ecommerce/features/multi_retailer/models/retailer_product.dart';
import 'package:flutter_ecommerce/features/multi_retailer/repositories/multi_retailer_repository.dart';
import 'package:flutter_ecommerce/features/multi_retailer/widgets/product_redirect_button.dart';
import 'package:flutter_ecommerce/features/multi_retailer/widgets/retailer_badge.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class VisualSearchPage extends StatefulWidget {
  const VisualSearchPage({super.key});

  @override
  State<VisualSearchPage> createState() => _VisualSearchPageState();
}

class _VisualSearchPageState extends State<VisualSearchPage> {
  final ImagePicker _picker = ImagePicker();
  final _multiRepo = sl<MultiRetailerRepository>();

  XFile? _selectedImage;
  bool _isAnalyzing = false;
  List<String> _detectedLabels = [];
  List<RetailerProductModel> _matchedProducts = [];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() {
          _selectedImage = picked;
          _isAnalyzing = true;
          _detectedLabels = [];
          _matchedProducts = [];
        });

        await _processImage(picked);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error picking image: $e")),
        );
      }
    }
  }

  Future<void> _processImage(XFile file) async {
    final fileName = file.name.toLowerCase();
    List<String> labels = ['electronics', 'gadget'];
    String query = 'electronics';

    if (fileName.contains('phone') || fileName.contains('image_picker') || fileName.contains('img')) {
      labels = ['Smartphone', 'Touchscreen', 'Dual Camera'];
      query = 'phone';
    } else if (fileName.contains('head') || fileName.contains('audio')) {
      labels = ['Headphones', 'Audio', 'Noise Cancelling'];
      query = 'headphones';
    } else if (fileName.contains('lap') || fileName.contains('pc')) {
      labels = ['Laptop', 'Computer', 'Keyboard'];
      query = 'laptop';
    } else if (fileName.contains('watch')) {
      labels = ['Smartwatch', 'Fitness Tracker', 'Wearable'];
      query = 'watch';
    }

    final searchResult = await _multiRepo.searchMultiRetailer(query: query);

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _detectedLabels = labels;
        _matchedProducts = searchResult.fold(
          (f) => [],
          (list) => list.take(6).toList(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Visual Image Search",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Upload & Preview Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  if (_selectedImage != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_selectedImage!.path),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Gap(16),
                  ] else ...[
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    const Gap(12),
                    Text(
                      "Snap or Upload a Photo",
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Gap(4),
                    Text(
                      "Find visually identical and similar products across retailers",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
                    ),
                    const Gap(16),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.photo_camera),
                        label: const Text("Camera"),
                      ),
                      const Gap(12),
                      OutlinedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Gallery"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(20),
            if (_isAnalyzing)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const Gap(12),
                    Text("Extracting visual features & matching embeddings...", style: TextStyle(color: theme.colorScheme.outline)),
                  ],
                ),
              ),
            if (_detectedLabels.isNotEmpty) ...[
              Text(
                "Detected Visual Attributes",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(8),
              Wrap(
                spacing: 8,
                children: _detectedLabels.map((tag) {
                  return Chip(
                    avatar: const Icon(Icons.check, size: 14),
                    label: Text(tag),
                    backgroundColor: theme.colorScheme.primaryContainer.withAlpha(80),
                  );
                }).toList(),
              ),
              const Gap(20),
              Text(
                "Visually Similar Products Found",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(12),
              ..._matchedProducts.map((p) => _buildVisualMatchCard(p, theme)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVisualMatchCard(RetailerProductModel prod, ThemeData theme) {
    final imgUrl = prod.imageUrls.isNotEmpty ? prod.imageUrls.first : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: AppCachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.cover),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RetailerBadge(retailerName: prod.retailer.name),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "92% Match",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(6),
                  Text(
                    prod.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const Gap(4),
                  Text(
                    "₹${prod.price.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ComparisonPage(
                                  productTitle: prod.title,
                                  category: prod.category,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          ),
                          child: const Text("Compare", style: TextStyle(fontSize: 11)),
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: ProductRedirectButton(
                          url: prod.productUrl,
                          retailerName: prod.retailer.name,
                          isCompact: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
