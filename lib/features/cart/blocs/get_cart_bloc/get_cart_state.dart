// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_cart_bloc.dart';

typedef GetCartState = BaseState<GetCartModel>;

class GetCartModel {
  final List<Cart> carts;
  final List<Cart> selectedCarts;
  final bool isAllCartSelected;
  final double subTotal;
  GetCartModel(
      {required this.carts,
      this.selectedCarts = const [],
      this.isAllCartSelected = false, this.subTotal=0.0});
}
