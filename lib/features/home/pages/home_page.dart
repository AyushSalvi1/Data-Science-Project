import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/widgets/app_loading.dart';
import 'package:flutter_ecommerce/features/ai_assistant/pages/ai_assistant_page.dart';
import 'package:flutter_ecommerce/features/category/blocs/get_category_bloc/get_category_bloc.dart';
import 'package:flutter_ecommerce/features/category/widgets/category_list.dart';
import 'package:flutter_ecommerce/features/comparison/pages/comparison_page.dart';
import 'package:flutter_ecommerce/features/product/blocs/get_product_bloc/get_product_bloc.dart';
import 'package:flutter_ecommerce/features/product/widgets/product_grid.dart';
import 'package:flutter_ecommerce/features/search/widgets/app_search_box.dart';
import 'package:flutter_ecommerce/features/visual_search/pages/visual_search_page.dart';
import 'package:flutter_ecommerce/features/wishlist/pages/wishlist_page.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedStore = 'All Stores';

  final List<String> _stores = [
    'All Stores',
    'Amazon India',
    'Flipkart',
    'Croma',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF0EA5E9)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.waves, color: Colors.white, size: 20),
            ),
            const Gap(10),
            RichText(
              text: TextSpan(
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
                children: const [
                  TextSpan(text: "Shop", style: TextStyle(color: Color(0xFF0F172A))),
                  TextSpan(text: "Wave", style: TextStyle(color: Color(0xFF4F46E5))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows_rounded, color: Color(0xFF4F46E5)),
            tooltip: "Compare Products",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ComparisonPage()),
              );
            },
          ),
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
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFFF43F5E)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            tooltip: "Gemini AI Copilot",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AIAssistantPage()),
              );
            },
          ),
          const Gap(6),
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
                // AI Copilot Hero Banner
                SliverToBoxAdapter(
                  child: _buildAIBanner(context, theme),
                ),
                // Categories
                SliverToBoxAdapter(
                  child: ProductCategories(
                    categories: categories,
                  ),
                ),
                // Store Filter Pills
                SliverToBoxAdapter(
                  child: _buildStoreFilterPills(theme),
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

  Widget _buildStoreFilterPills(ThemeData theme) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _stores.length,
        separatorBuilder: (_, __) => const Gap(8),
        itemBuilder: (context, index) {
          final store = _stores[index];
          final isSelected = store == _selectedStore;
          return FilterChip(
            selected: isSelected,
            label: Text(
              store,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
            ),
            backgroundColor: Colors.white,
            selectedColor: const Color(0xFF4F46E5),
            checkmarkColor: Colors.white,
            side: BorderSide(
              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
            ),
            onSelected: (selected) {
              setState(() {
                _selectedStore = store;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildAIBanner(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F172A), // Dark obsidian
            Color(0xFF1E1B4B), // Deep indigo
            Color(0xFF312E81), // Violet midnight
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withAlpha(45),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFF4338CA).withAlpha(100), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFF818CF8), size: 18),
              ),
              const Gap(10),
              const Text(
                "Gemini AI Shopping Copilot",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Multi-Store AI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(10),
          const Text(
            "Instant price comparison across Amazon India, Flipkart, and Croma with intelligent budget parsing and drop alerts.",
            style: TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 12,
              height: 1.45,
            ),
          ),
          const Gap(14),
          // Quick Suggested Prompts
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPromptChip("📱 Best Phone under 25k", context),
                const Gap(8),
                _buildPromptChip("💻 Gaming Laptops", context),
                const Gap(8),
                _buildPromptChip("🎧 Sony ANC Earbuds", context),
              ],
            ),
          ),
          const Gap(14),
          Row(
            children: [
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIAssistantPage()),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 15),
                label: const Text(
                  "Ask AI Copilot",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Gap(8),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VisualSearchPage()),
                  );
                },
                icon: const Icon(Icons.camera_alt_outlined, size: 15),
                label: const Text(
                  "Visual Search",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF64748B)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String title, BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AIAssistantPage(
              initialPrompt: title.replaceAll(RegExp(r'[^\w\s₹]'), '').trim(),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withAlpha(30)),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFE2E8F0),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalizedHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10).copyWith(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.local_fire_department, size: 16, color: Color(0xFFEA580C)),
              ),
              const Gap(8),
              Text(
                "Trending Multi-Store Deals",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Verified Best Prices",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F46E5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildProductList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      sliver: BlocBuilder<GetProductBloc, GetProductState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (products) {
              return BuildProductGrid(products: products);
            },
            orElse: () => const SliverToBoxAdapter(),
          );
        },
      ),
    );
  }
}
