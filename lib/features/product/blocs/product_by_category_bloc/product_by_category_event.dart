part of 'product_by_category_bloc.dart';

@freezed
class ProductByCategoryEvent with _$ProductByCategoryEvent {
  const factory ProductByCategoryEvent.get(String categoryId) = _Get;
}