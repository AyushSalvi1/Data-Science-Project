import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/category/repositories/category_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_event.dart';
part 'category_state.dart';
part 'category_bloc.freezed.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  CategoryBloc({
    required CategoryRepository repo,
  })  : _categoryRepository = repo,
        super(CategoryState.initial()) {
    on<CategoryEvent>((event, emit) async {
      await event.map(
        add: (e) async {
          emit(CategoryState.loading());
          final failureOrCategory = await _categoryRepository.addCategory(
            name: e.name,
            imageFile: e.imageFile,
          );
          emit(
            failureOrCategory.fold(
              (failure) => CategoryState.failure(failure),
              (category) => CategoryState.loaded(category),
            ),
          );
        },
      );
    });
  }
}
