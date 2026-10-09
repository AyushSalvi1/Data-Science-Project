class PriceHistoryItem {
  final DateTime date;
  final double price;
  final String retailer;

  PriceHistoryItem({
    required this.date,
    required this.price,
    required this.retailer,
  });

  factory PriceHistoryItem.fromJson(Map<String, dynamic> json) {
    return PriceHistoryItem(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      retailer: json['retailer'] as String? ?? 'ShopWave',
    );
  }
}

class PriceAnalytics {
  final String productId;
  final double currentPrice;
  final double lowestPrice;
  final double highestPrice;
  final String trend; // "dropping", "stable", "rising"
  final double potentialSavings;
  final List<PriceHistoryItem> history;

  PriceAnalytics({
    required this.productId,
    required this.currentPrice,
    required this.lowestPrice,
    required this.highestPrice,
    required this.trend,
    required this.potentialSavings,
    required this.history,
  });
}
