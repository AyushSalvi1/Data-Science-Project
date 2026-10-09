import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/price_tracking/models/price_history_model.dart';
import 'package:flutter_ecommerce/features/price_tracking/repositories/price_tracking_repository.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class PriceHistoryWidget extends StatefulWidget {
  final Product product;

  const PriceHistoryWidget({super.key, required this.product});

  @override
  State<PriceHistoryWidget> createState() => _PriceHistoryWidgetState();
}

class _PriceHistoryWidgetState extends State<PriceHistoryWidget> {
  final _repo = sl<PriceTrackingRepository>();
  PriceAnalytics? _analytics;
  bool _isLoading = true;
  bool _alertSet = false;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final result = await _repo.getPriceAnalytics(widget.product);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _analytics = result.fold((f) => null, (a) => a);
      });
    }
  }

  void _onSetAlert() {
    if (_analytics == null) return;
    final target = _analytics!.currentPrice * 0.95; // 5% drop target
    _repo.setPriceDropAlert(productId: widget.product.id, targetPrice: target);
    setState(() {
      _alertSet = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Price drop alert set for ₹${target.toStringAsFixed(0)}!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_analytics == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDropping = _analytics!.trend == 'dropping';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.trending_down, color: theme.colorScheme.primary, size: 20),
                  const Gap(8),
                  Text(
                    "Price Intelligence",
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDropping ? Colors.green.withAlpha(30) : Colors.orange.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isDropping ? "Price Dropped 🔥" : "Price Stable",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDropping ? Colors.green[800] : Colors.orange[800],
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat("Lowest (30d)", "₹${_analytics!.lowestPrice.toStringAsFixed(0)}", Colors.green[700]),
              _buildStat("Current", "₹${_analytics!.currentPrice.toStringAsFixed(0)}", theme.colorScheme.primary),
              _buildStat("Potential Savings", "₹${_analytics!.potentialSavings.toStringAsFixed(0)}", Colors.deepOrange),
            ],
          ),
          const Gap(16),
          // Timeline Points Mini Chart
          Text(
            "Recent 30-Day Trend",
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _analytics!.history.map((pt) {
              final isCurrent = pt.price == _analytics!.currentPrice;
              return Column(
                children: [
                  Text(
                    "₹${(pt.price / 1000).toStringAsFixed(1)}k",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    ),
                  ),
                  const Gap(4),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    DateFormat.MMMd().format(pt.date),
                    style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              );
            }).toList(),
          ),
          const Gap(16),
          OutlinedButton.icon(
            onPressed: _alertSet ? null : _onSetAlert,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
            icon: Icon(_alertSet ? Icons.check_circle : Icons.notifications_active_outlined),
            label: Text(_alertSet ? "Alert Active for Price Drops" : "Notify Me of Price Drops"),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color? color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const Gap(4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
