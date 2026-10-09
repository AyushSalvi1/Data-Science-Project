import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/widgets/custom_cached_network_image.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/cart/blocs/cart_bloc/cart_bloc.dart';
import 'package:flutter_ecommerce/features/cart/blocs/get_cart_bloc/get_cart_bloc.dart';
import 'package:flutter_ecommerce/features/cart/models/cart.dart';
import 'package:flutter_ecommerce/features/cart/widgets/cart_bloc_listener.dart';
import 'package:flutter_ecommerce/features/product/widgets/item_quantity_controller.dart';
import 'package:flutter_ecommerce/features/product/widgets/product_price.dart';
import 'package:gap/gap.dart';

class CartCard extends StatelessWidget {
  CartCard({
    super.key,
    required this.cart,
  });

  final Cart cart;
  final CartBloc _cartBloc = sl<CartBloc>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withAlpha((255 * 0.1).toInt() ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: LimitedBox(
            maxHeight: 158,
            child: Row(
              children: [
                _buildCheckBox(),
                _buildProductImage(),
                Gap(8),
                _buildProductDetail(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckBox() {
    return Checkbox(
      value: cart.isSelected,
      onChanged: (value) =>
          sl<GetCartBloc>().add(GetCartEvent.changeSelection(cart)),
    );
  }

  Widget _buildProductImage() {
    return LayoutBuilder(builder: (context, constrainsts) {
      return SizedBox(
        width: 116,
        height: constrainsts.maxHeight * 0.7,
        child: Container(
          // margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((255 * 0.05).toInt()),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppCachedNetworkImage(
            imageUrl: cart.product.images.firstOrNull?.url,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  Widget _buildProductDetail(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Column(
          // spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cart.product.name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Gap(4),
            Transform.scale(
                scale: 0.8,
                alignment: Alignment.centerLeft,
                child: ProductPrice(
                    direction: Axis.horizontal, product: cart.product)),
            _cartQuantity(),
            Gap(4),
          ],
        ),
      ),
    );
  }

  CartBlocListener _cartQuantity() {
    return CartBlocListener(
      bloc: _cartBloc,
      child: Builder(builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ItemQuantityController(
            getQuantity: (quantity) {},
            initialQuantity: cart.quantity,
            onDecrementQuantity: () => _cartBloc.add(CartEvent.update(
                id: cart.id, updatedTotalQuantity: cart.quantity - 1)),
            onIncrementQuantity: () => _cartBloc.add(
              CartEvent.update(
                  id: cart.id, updatedTotalQuantity: cart.quantity + 1),
            ),
          ),
        );
      }),
    );
  }
}
