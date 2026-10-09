import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/utils/auth_utils.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/address/blocs/get_address_bloc/get_address_bloc.dart';
import 'package:flutter_ecommerce/features/cart/blocs/cart_bloc/cart_bloc.dart';
import 'package:flutter_ecommerce/features/cart/models/cart_form.dart';
import 'package:flutter_ecommerce/features/cart/widgets/cart_bloc_listener.dart';
import 'package:flutter_ecommerce/features/order/models/buy_now_and_cart_order_models.dart';
import 'package:flutter_ecommerce/features/product/widgets/item_quantity_controller.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:gap/gap.dart';
import 'package:flutter_ecommerce/common/widgets/custom_cached_network_image.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:flutter_ecommerce/features/product/widgets/product_price.dart';
import 'package:flutter_ecommerce/features/wishlist/blocs/wishlist_bloc/wishlist_bloc.dart';
import 'package:flutter_ecommerce/features/wishlist/blocs/wishlist_bloc/wishlist_state.dart';
import 'package:flutter_ecommerce/features/price_tracking/widgets/price_history_widget.dart';
import 'package:flutter_ecommerce/features/review/widgets/product_reviews_section.dart';
import 'package:flutter_ecommerce/features/comparison/pages/comparison_page.dart';
import 'package:go_router/go_router.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    this.product,
  });
  final Product? product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  double currentImageIndex = 0.0;
  Product? product;
  int _quantity = 1;
  late final CartBloc _cartBloc;

  @override
  void initState() {
    product = widget.product;
    _cartBloc = sl<CartBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return product != null
        ? Scaffold(
            backgroundColor: ColorScheme.of(context).surface,
            appBar: AppBar(
              title: Text(
                product!.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Link copied: ${product!.name}")),
                    );
                  },
                ),
                BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, state) {
                    final isWishlisted = (state is WishlistLoadedState) &&
                        state.isWishlisted(product!.id);
                    return IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border_outlined,
                        color: isWishlisted ? Colors.red : null,
                      ),
                      onPressed: () {
                        context.read<WishlistBloc>().add(
                              ToggleWishlistEvent(product!),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isWishlisted
                                  ? "Removed from wishlist"
                                  : "Added to wishlist",
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(child: _bottomSheet()),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageCarousel(),
                  _buildProductDetail(),
                  _buildSpecifications(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ComparisonPage(
                              productTitle: product!.name,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.compare_arrows_rounded),
                      label: const Text("Compare Across Amazon, Flipkart & Croma"),
                    ),
                  ),
                  PriceHistoryWidget(product: product!),
                  ProductReviewsSection(productId: product!.id),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _bottomSheet() {
    return Card(
      color: ColorScheme.of(context).surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
            .copyWith(top: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ItemQuantityController(
              label: "Quantity",
              getQuantity: (quantity) {
                _quantity = quantity;
              },
            ),
            Gap(12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: BlocBuilder<GetAddressBloc, GetAddressState>(
                    builder: (context, state) {
                      return OutlinedButton(
                        onPressed: _onBuyNow,
                        child: Text("Buy now"),
                      );
                    },
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: CartBlocListener(
                    bloc: _cartBloc,
                    child: FilledButton(
                      onPressed: () async => await AuthUtil.checkAuthAndProceed(
                          context, _onAddToCart),
                      child: Text("Add to cart"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        CarouselSlider(
          items: product!.images.map((image) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surfaceContainerLowest,
              ),
              child: AppCachedNetworkImage(
                imageUrl: image.url,
                fit: BoxFit.contain,
              ),
            );
          }).toList(),
          options: CarouselOptions(
            aspectRatio: 1,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentImageIndex = index.toDouble();
              });
            },
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((0.6*255).toInt()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _buildPageIndicator(
                currentImageIndex,
                product!.images.length,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetail() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product!.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Gap(8),
                    ProductPrice(product: product!),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorScheme.of(context).primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${product!.stockQuantity} in stock',
                  style: TextStyle(
                    color: ColorScheme.of(context).onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Gap(16),
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Gap(8),
          Text(
            product!.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorScheme.of(context).onSurfaceVariant,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Gap(12),
          // _buildSpecificationItem('Brand', 'ShopWave Original'),
          _buildSpecificationItem('Category', 'Electronics'),
          if (product!.discountPercentage != null)
            _buildSpecificationItem(
              'Discount',
              '${product!.discountPercentage!.toStringAsFixed(0)}% OFF',
            ),
        ],
      ),
    );
  }

  Widget _buildSpecificationItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: ColorScheme.of(context).onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(8),
          Text(
            ': ',
            style: TextStyle(
              color: ColorScheme.of(context).onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: ColorScheme.of(context).onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(double currentIndex, int totalLength) {
    return DotsIndicator(
      dotsCount: totalLength,
      position: currentIndex,
      decorator: DotsDecorator(
        activeColor: Colors.white,
        color: Colors.white.withAlpha((0.5*255).toInt()),
        size: const Size(8, 8),
        activeSize: const Size(24, 8),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  void _onAddToCart() {
    final cart = CartForm(productId: product!.id, quantity: _quantity);
    _cartBloc.add(CartEvent.add(cart));
  }

  void _onBuyNow() {
    context.pushNamed(AppRouteName.checkout,
        extra: BuyNowOrderModel(
          product: product!,
          quantity: _quantity,
          totalAmount: product!.currentAmount * _quantity,
        ));
  }
}
