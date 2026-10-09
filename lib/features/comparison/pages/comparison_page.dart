import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/widgets/app_loading.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/comparison/models/comparison_model.dart';
import 'package:flutter_ecommerce/features/multi_retailer/repositories/multi_retailer_repository.dart';
import 'package:flutter_ecommerce/features/multi_retailer/widgets/product_redirect_button.dart';
import 'package:flutter_ecommerce/features/multi_retailer/widgets/retailer_badge.dart';
import 'package:gap/gap.dart';

class ComparisonPage extends StatefulWidget {
  final String productTitle;
  final String? category;

  const ComparisonPage({
    super.key,
    required this.productTitle,
    this.category,
  });

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  final _repo = sl<MultiRetailerRepository>();
  ProductComparisonModel? _comparison;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchComparison();
  }

  Future<void> _fetchComparison() async {
    final result = await _repo.compareProducts(
      productTitle: widget.productTitle,
      category: widget.category,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
        result.fold(
          (failure) => _error = failure.toString(),
          (comp) => _comparison = comp,
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
          "Retailer Price Comparison",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: _isLoading
          ? AppLoading.center()
          : _error != null
              ? Center(child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)))
              : _comparison == null || _comparison!.bestOffersByRetailer.isEmpty
                  ? const Center(child: Text("No comparison offers available."))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _comparison!.productTitle,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Gap(12),
                          // Analytical Verdict Card
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer.withAlpha(80),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                                const Gap(12),
                                Expanded(
                                  child: Text(
                                    _comparison!.verdict,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(20),
                          Text(
                            "Offers Across 3+ Stores",
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Gap(12),
                          // Side-by-side comparison cards
                          ..._comparison!.bestOffersByRetailer.map((offer) {
                            return _buildOfferCard(offer, theme);
                          }),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildOfferCard(ComparisonMatrixItemModel offer, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: offer.isBestPrice
              ? Colors.green
              : theme.colorScheme.outlineVariant,
          width: offer.isBestPrice ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RetailerBadge(retailerName: offer.retailer),
                if (offer.isBestPrice)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "BEST PRICE",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (offer.isHighestRated && !offer.isBestPrice)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.amber[800],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "TOP RATED",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const Gap(10),
            Text(
              offer.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const Gap(8),
            Row(
              children: [
                Text(
                  "₹${offer.price.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                if (offer.originalPrice != null && offer.originalPrice! > offer.price) ...[
                  const Gap(8),
                  Text(
                    "₹${offer.originalPrice!.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 13,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ],
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Gap(4),
                    Text(
                      "${offer.rating.toStringAsFixed(1)} (${offer.reviewCount})",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: offer.keyHighlights.map((hl) {
                return Chip(
                  label: Text(hl, style: const TextStyle(fontSize: 10)),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                );
              }).toList(),
            ),
            const Gap(12),
            SizedBox(
              width: double.infinity,
              child: ProductRedirectButton(
                url: offer.productUrl,
                retailerName: offer.retailer,
                isCompact: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
