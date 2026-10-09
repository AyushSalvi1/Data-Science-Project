import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/address/models/address_model.dart';
import 'package:flutter_ecommerce/features/address/repositories/address_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_address_event.dart';
part 'get_address_state.dart';
part 'get_address_bloc.freezed.dart';

class GetAddressBloc extends Bloc<GetAddressEvent, GetAddressState> {
  final AddressRepository _addressRepo;
  GetAddressBloc({required AddressRepository repo})
      : _addressRepo = repo,
        super(GetAddressState.initial()) {
    on<GetAddressEvent>((event, emit) async {
      await event.when(get: () async {
        emit(GetAddressState.loading());
        final failureOrAddress = await _addressRepo.getUserAddress();
        failureOrAddress.fold(
          (failure) => emit(GetAddressState.failure(failure)),
          (address) => emit(GetAddressState.loaded(address)),
        );
      });
    });
  }
}
