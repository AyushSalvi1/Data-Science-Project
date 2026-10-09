import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/category/models/category.dart';
import 'package:flutter_ecommerce/features/category/repositories/category_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_category_event.dart';
part 'get_category_state.dart';
part 'get_category_bloc.freezed.dart';

class GetCategoryBloc extends Bloc<GetCategoryEvent, GetCategoryState> {
  final CategoryRepository _categoryRepository;
  GetCategoryBloc({
    required CategoryRepository repo,
  })  : _categoryRepository = repo,
        super(GetCategoryState.initial()) {
    on<GetCategoryEvent>((event, emit) async {
      await event.map(
        get: (e) async {
          emit(GetCategoryState.loading());
          final failureOrCategory = await _categoryRepository.getCategories();
          emit(
            failureOrCategory.fold(
              (failure) => GetCategoryState.failure(failure),
              (categories) => GetCategoryState.loaded(categories),
            ),
          );
        },
      );
    });
  }
}
