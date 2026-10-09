import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/features/multi_retailer/widgets/retailer_badge.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('RetailerBadge renders correctly for Amazon India', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RetailerBadge(retailerName: 'Amazon India'),
          ),
        ),
      );

      expect(find.text('Amazon India'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('RetailerBadge renders correctly for Flipkart', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RetailerBadge(retailerName: 'Flipkart'),
          ),
        ),
      );

      expect(find.text('Flipkart'), findsOneWidget);
      expect(find.byIcon(Icons.flash_on), findsOneWidget);
    });

    testWidgets('RetailerBadge renders correctly for Croma', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RetailerBadge(retailerName: 'Croma'),
          ),
        ),
      );

      expect(find.text('Croma'), findsOneWidget);
      expect(find.byIcon(Icons.storefront), findsOneWidget);
    });
  });
}
