import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/widgets/custom_cached_network_image.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/ai_assistant/pages/ai_assistant_page.dart';
import 'package:flutter_ecommerce/features/comparison/pages/comparison_page.dart';
import 'package:flutter_ecommerce/features/multi_retailer/models/retailer_product.dart';
import 'package:flutter_ecommerce/features/multi_retailer/repositories/multi_retailer_repository.dart';
import 'package:flutter_ecommerce/features/multi_retailer/widgets/product_redirect_button.dart';
import 'package:flutter_ecommerce/features/multi_retailer/widgets/retailer_badge.dart';
import 'package:flutter_ecommerce/features/product/widgets/product_card.dart';
import 'package:flutter_ecommerce/features/search/blocs/search_bloc/search_bloc.dart';
import 'package:flutter_ecommerce/features/search/widgets/search_field.dart';
import 'package:flutter_ecommerce/features/search/widgets/search_filters.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  Timer? _debounce;
  double? _minPrice;
  double? _maxPrice;
  bool _showDiscountedOnly = false;
  final _searchBloc = sl<SearchBloc>();
  final _multiRetailerRepo = sl<MultiRetailerRepository>();

  bool _isMultiStoreMode = true;
  String _sortBy = 'relevance';
  List<RetailerProductModel> _multiRetailerResults = [];
  bool _isLoadingMultiStore = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _performMultiStoreSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _applyFilters();
    });
  }

  void _applyFilters() {
    if (_isMultiStoreMode) {
      _performMultiStoreSearch();
    } else {
      _searchBloc.add(SearchEvent.search(
        _searchController.text,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        showDiscountedOnly: _showDiscountedOnly,
      ));
    }
  }

  Future<void> _performMultiStoreSearch() async {
    setState(() => _isLoadingMultiStore = true);
    final result = await _multiRetailerRepo.searchMultiRetailer(
      query: _searchController.text,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      sortBy: _sortBy,
    );
    if (mounted) {
      setState(() {
        _isLoadingMultiStore = false;
        _multiRetailerResults = result.fold((f) => [], (items) => items);
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _minPriceController.clear();
      _maxPriceController.clear();
      _minPrice = null;
      _maxPrice = null;
      _showDiscountedOnly = false;
      _sortBy = 'relevance';
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildDiscover(context),
            _buildSearchField(context),
            _buildSourceAndSortBar(context),
            _buildSearchFilter(),
            if (_isMultiStoreMode)
              _buildMultiStoreProductList(context)
            else
              _buildLocalProducts(),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSearchField(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0.0,
      title: SearchField(searchController: _searchController),
    );
  }

  Widget _buildSourceAndSortBar(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Mode Selector
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(
                        value: true,
                        label: Text("All Stores (Amazon, Flipkart, Croma)", style: TextStyle(fontSize: 11)),
                        icon: Icon(Icons.public, size: 14),
                      ),
                      ButtonSegment<bool>(
                        value: false,
                        label: Text("ShopWave Only", style: TextStyle(fontSize: 11)),
                        icon: Icon(Icons.store, size: 14),
                      ),
                    ],
                    selected: {_isMultiStoreMode},
                    onSelectionChanged: (val) {
                      setState(() {
                        _isMultiStoreMode = val.first;
                      });
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
            const Gap(8),
            // Sorting & AI Assistant quick pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sort Dropdown
                Row(
                  children: [
                    const Icon(Icons.sort, size: 16),
                    const Gap(6),
                    DropdownButton<String>(
                      value: _sortBy,
                      underline: const SizedBox.shrink(),
                      isDense: true,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface),
                      items: const [
                        DropdownMenuItem(value: 'relevance', child: Text("Relevance")),
                        DropdownMenuItem(value: 'price_asc', child: Text("Price: Low to High")),
                        DropdownMenuItem(value: 'price_desc', child: Text("Price: High to Low")),
                        DropdownMenuItem(value: 'rating', child: Text("Customer Rating")),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _sortBy = val);
                          _applyFilters();
                        }
                      },
                    ),
                  ],
                ),
                ActionChip(
                  avatar: const Icon(Icons.auto_awesome, size: 14, color: Colors.amber),
                  label: const Text("Ask AI Assistant", style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AIAssistantPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilter() {
    return SliverToBoxAdapter(
      child: SearchFilters(
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        minPriceController: _minPriceController,
        maxPriceController: _maxPriceController,
        showDiscountedOnly: _showDiscountedOnly,
        onMinPriceChanged: (value) => setState(() => _minPrice = value),
        onMaxPriceChanged: (value) => setState(() => _maxPrice = value),
        onDiscountedOnlyChanged: (value) =>
            setState(() => _showDiscountedOnly = value),
        onApplyFilters: _applyFilters,
        onClearFilters: _clearFilters,
      ),
    );
  }

  SliverToBoxAdapter _buildDiscover(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          title: Text(
            'Search & Compare',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiStoreProductList(BuildContext context) {
    if (_isLoadingMultiStore) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_multiRetailerResults.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text("No multi-store products found for this query.")),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = _multiRetailerResults[index];
            return _buildMultiStoreCard(product, Theme.of(context));
          },
          childCount: _multiRetailerResults.length,
        ),
      ),
    );
  }

  Widget _buildMultiStoreCard(RetailerProductModel prod, ThemeData theme) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const Gap(2),
                              Text(
                                "${prod.rating} (${prod.reviewCount})",
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
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
                      Row(
                        children: [
                          Text(
                            "₹${prod.price.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          if (prod.originalPrice != null && prod.originalPrice! > prod.price) ...[
                            const Gap(6),
                            Text(
                              "₹${prod.originalPrice!.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ComparisonPage(
                            productTitle: prod.title,
                            category: prod.category,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                    child: const Text("Compare Stores", style: TextStyle(fontSize: 12)),
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
    );
  }

  BlocBuilder<SearchBloc, SearchState> _buildLocalProducts() {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          failure: (failure) => SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${failure.toString()}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          loaded: (products) => products.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: Text('No products found'),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () => context.pushNamed(
                              AppRouteName.productDetailPage,
                              pathParameters: {"id": product.id.toString()},
                              extra: product),
                          child: ProductCard(
                            product: product,
                          ),
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ),
          orElse: () => const SliverFillRemaining(
            child: Center(
              child: Text('Start searching for products'),
            ),
          ),
        );
      },
    );
  }
}
