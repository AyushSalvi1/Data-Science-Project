part of 'product_bloc.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.add(ProductForm product) = _Add;
  const factory ProductEvent.update(String productId, ProductForm product) = _Update;
}