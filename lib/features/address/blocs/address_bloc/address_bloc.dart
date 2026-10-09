
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_ecommerce/core/state/base_state.dart';
import 'package:flutter_ecommerce/features/address/models/address_form.dart';
import 'package:flutter_ecommerce/features/address/repositories/address_repository.dart';

part 'address_bloc.freezed.dart';
part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository _addressRepo;
  AddressBloc({required AddressRepository repo})
      : _addressRepo = repo,
        super(AddressState.initial()) {
    on<AddressEvent>((event, emit) async {
      await event.when(
        add: (address) async {
          emit(AddressState.loading());
          final failureOrAddress = await _addressRepo.addAddress(address);
          return failureOrAddress.fold(
            (failure) => emit(AddressState.failure(failure)),
            (message) => emit(AddressState.loaded(message)),
          );
        },
      );
    });
  }
}
