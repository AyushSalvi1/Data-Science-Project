import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/widgets/app_loading.dart';
import 'package:flutter_ecommerce/features/ai_assistant/pages/ai_assistant_page.dart';
import 'package:flutter_ecommerce/features/category/blocs/get_category_bloc/get_category_bloc.dart';
import 'package:flutter_ecommerce/features/category/widgets/category_list.dart';
import 'package:flutter_ecommerce/features/product/blocs/get_product_bloc/get_product_bloc.dart';
import 'package:flutter_ecommerce/features/product/widgets/product_grid.dart';
import 'package:flutter_ecommerce/features/search/widgets/app_search_box.dart';
import 'package:flutter_ecommerce/features/visual_search/pages/visual_search_page.dart';
import 'package:flutter_ecommerce/features/wishlist/pages/wishlist_page.dart';
import 'package:gap/gap.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ShopWave",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: "My Wishlist",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Colors.amber),
            tooltip: "AI Shopping Assistant",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AIAssistantPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: AppSearchBoxUI(),
              ),
            ];
          },
          body: _buildBody(context, theme),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    return BlocBuilder<GetCategoryBloc, GetCategoryState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => AppLoading.center(),
          loaded: (categories) {
            return CustomScrollView(
              slivers: [
                // AI Assistant Feature Banner
                SliverToBoxAdapter(
                  child: _buildAIBanner(context, theme),
                ),
                // Categories
                SliverToBoxAdapter(
                  child: ProductCategories(
                    categories: categories,
                  ),
                ),
                // Personalized Deals Header
                SliverToBoxAdapter(
                  child: _buildPersonalizedHeader(context, theme),
                ),
                // Products Grid
                _buildProductList(),
              ],
            );
          },
          failure: (failure) => Center(child: Text(failure.toString())),
        );
      },
    );
  }

  Widget _buildAIBanner(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withAlpha(200),
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              ),
              const Gap(10),
              const Text(
                "AI Shopping Assistant",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(60),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Multi-Store",
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Gap(10),
          const Text(
            "Compare prices across Amazon, Flipkart, and Croma, find visual matches, and track price drops.",
            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
          ),
          const Gap(14),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIAssistantPage()),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 16),
                    Gap(6),
                    Text("Ask AI Assistant", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              const Gap(8),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VisualSearchPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_outlined, size: 16),
                    Gap(6),
                    Text("Visual Search", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizedHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12).copyWith(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.recommend, size: 20, color: Colors.deepOrange),
              const Gap(8),
              Text(
                "Personalized For You",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            "Best verified deals",
            style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildProductList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      sliver: BlocBuilder<GetProductBloc, GetProductState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (products) => BuildProductGrid(products: products),
            orElse: () => const SliverToBoxAdapter(),
          );
        },
      ),
    );
  }
}
