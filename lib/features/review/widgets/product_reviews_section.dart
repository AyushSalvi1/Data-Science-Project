import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/review/models/product_review.dart';
import 'package:flutter_ecommerce/features/review/repositories/review_repository.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ProductReviewsSection extends StatefulWidget {
  final String productId;

  const ProductReviewsSection({
    super.key,
    required this.productId,
  });

  @override
  State<ProductReviewsSection> createState() => _ProductReviewsSectionState();
}

class _ProductReviewsSectionState extends State<ProductReviewsSection> {
  final _reviewRepo = sl<ReviewRepository>();
  List<ProductReview> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final result = await _reviewRepo.getReviews(widget.productId);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _reviews = result.fold((f) => [], (list) => list);
      });
    }
  }

  double get _averageRating {
    if (_reviews.isEmpty) return 4.5;
    final sum = _reviews.fold<double>(0.0, (acc, r) => acc + r.rating);
    return sum / _reviews.length;
  }

  void _showAddReviewDialog() {
    double selectedRating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text("Write a Product Review"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Rate this product:"),
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starVal = index + 1.0;
                  return IconButton(
                    icon: Icon(
                      starVal <= selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        selectedRating = starVal;
                      });
                    },
                  );
                }),
              ),
              const Gap(12),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Your Feedback",
                  hintText: "What did you like or dislike about this product?",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () async {
                final comment = commentController.text.trim();
                Navigator.pop(ctx);
                if (comment.isNotEmpty) {
                  final result = await _reviewRepo.addReview(
                    productId: widget.productId,
                    rating: selectedRating,
                    comment: comment,
                  );
                  result.fold((f) => null, (newReview) {
                    setState(() {
                      _reviews.insert(0, newReview);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Review submitted successfully!")),
                    );
                  });
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ratings & Reviews",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _showAddReviewDialog,
                icon: const Icon(Icons.rate_review_outlined, size: 18),
                label: const Text("Write Review"),
              ),
            ],
          ),
          const Gap(12),
          // Rating Summary Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    _averageRating.toStringAsFixed(1),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < _averageRating.floor()
                            ? Icons.star
                            : (i < _averageRating ? Icons.star_half : Icons.star_border),
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                  const Gap(4),
                  Text(
                    "${_reviews.length} reviews",
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Gap(24),
              // Rating Breakdown Bars
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    final count = _reviews.where((r) => r.rating.round() == star).length;
                    final pct = _reviews.isNotEmpty ? count / _reviews.length : 0.2;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text("$star ★", style: const TextStyle(fontSize: 11)),
                          const Gap(8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 6,
                                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          const Gap(8),
                          Text("$count", style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const Gap(16),
          const Divider(),
          const Gap(8),
          // Reviews List
          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
          else
            ..._reviews.map((review) => _buildReviewItem(review, theme)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ProductReview review, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    review.userName,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
              Text(
                DateFormat.yMMMd().format(review.createdAt),
                style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const Gap(4),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 14,
              ),
            ),
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const Gap(6),
            Text(
              review.comment!,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ],
          const Gap(8),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
