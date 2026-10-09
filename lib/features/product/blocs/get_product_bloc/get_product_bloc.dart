import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:flutter_ecommerce/features/product/repositories/product_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_product_event.dart';
part 'get_product_state.dart';
part 'get_product_bloc.freezed.dart';

class GetProductBloc extends Bloc<GetProductEvent, GetProductState> {
  final ProductRepository _productRepository;

  GetProductBloc({required ProductRepository repo})
      : _productRepository = repo,
        super(GetProductState.initial()) {
    {
      on<GetProductEvent>((event, emit) async {
        await event.when(get: () async {
          final failureOrProducts = await _productRepository.getProducts();
          failureOrProducts.fold(
              (failure) => emit(GetProductState.failure(failure)),
              (products) => emit(GetProductState.loaded(products)));
        });
      });
    }
  }
}
