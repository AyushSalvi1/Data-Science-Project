part of 'category_bloc.dart';

@freezed
class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.add(
      {required String name, required File imageFile}) = _Add;
}
