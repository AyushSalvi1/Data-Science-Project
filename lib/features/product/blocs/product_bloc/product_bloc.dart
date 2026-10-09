import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/product/models/product_form.dart';
import 'package:flutter_ecommerce/features/product/repositories/product_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  ProductBloc({required ProductRepository repo})
      : _productRepository = repo,
        super(const ProductState.initial()) {
    on<ProductEvent>((event, emit) async {
      await event.when<Future<void>>(
        add: (product) async {
          emit(const ProductState.loading());
          final result = await _productRepository.addProduct(product);
          result.fold(
            (failure) => emit(ProductState.failure(failure)),
            (success) => emit(ProductState.loaded(success)),
          );
        },
        update: (productId, product) async {
          emit(const ProductState.loading());
          final result = await _productRepository.updateProduct(product);
          result.fold(
            (failure) => emit(ProductState.failure(failure)),
            (success) => emit(ProductState.loaded(success)),
          );
        },
      );
    });
  }
}
