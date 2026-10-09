part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.search(
    String query, {
    double? minPrice,
    double? maxPrice,
    bool? showDiscountedOnly,
  }) = _Search;
  const factory SearchEvent.clear() = _Clear;
}
