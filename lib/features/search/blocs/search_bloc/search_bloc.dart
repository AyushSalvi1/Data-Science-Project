import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/product/models/product.dart';
import 'package:flutter_ecommerce/features/product/repositories/product_repository.dart';
import 'package:flutter_ecommerce/features/search/models/product_search_params.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository _productRepository;
  SearchBloc({required ProductRepository repo})
      : _productRepository = repo,
        super(SearchState.initial()) {
    on<SearchEvent>((event, emit) async {
      await event.when(
        search: (query, minPrice, maxPrice, showDiscountedOnly) async {
          emit(const SearchState.loading());
          final params = ProductSearchParams(
            query: query,
            minPrice: minPrice,
            maxPrice: maxPrice,
            hasDiscount: showDiscountedOnly,
          );
          final failureOrProducts =
              await _productRepository.searchProducts(params);

          failureOrProducts.fold(
            (failure) => emit(SearchState.failure(failure)),
            (products) => emit(SearchState.loaded(products)),
          );
        },
        clear: () async {
          emit(const SearchState.initial());
        },
      );
    });
  }
}
