// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/utils/loading_dialog.dart';
import 'package:flutter_ecommerce/common/utils/toast_msg.dart';
import 'package:flutter_ecommerce/common/widgets/app_form_builder_text.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/address/blocs/address_bloc/address_bloc.dart';
import 'package:flutter_ecommerce/features/address/blocs/get_address_bloc/get_address_bloc.dart';
import 'package:flutter_ecommerce/features/address/models/address_form.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});
  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Address"),
      ),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
          child: Column(
            spacing: 12,
            children: [
              AppFormBuilderTextField(
                name: 'address',
                hintText: 'Address *',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ]),
              ),
              AppFormBuilderTextField(
                name: 'city',
                hintText: 'City *',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              Row(
                children: [
                  Expanded(
                      child: AppFormBuilderTextField(
                    name: 'state',
                    hintText: 'State *',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(3),
                    ]),
                  )),
                  Gap(12),
                  Expanded(
                      child: AppFormBuilderTextField(
                    name: 'zip',
                    hintText: 'Zip code',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.zipCode(checkNullOrEmpty: false),
                    ]),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(child: _buildSaveButton()),
    );
  }

  Padding _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: SizedBox(
          width: double.maxFinite,
          child: BlocListener<AddressBloc, AddressState>(
            listener: (context, state) {
              state.whenOrNull(
                loading: () => AppProgressIndicator.show(context),
                loaded: (data) {
                  AppToast.success(context, data);
                  AppProgressIndicator.hide(context);
                  sl<GetAddressBloc>().add(GetAddressEvent.get());
                  context.pop();
                },
                failure: (failure) {
                  AppToast.error(context, failure.toString());
                  AppProgressIndicator.hide(context);
                },
              );
            },
            child: FilledButton(onPressed: _onSaveAddress, child: Text("Save")),
          )),
    );
  }

  void _onSaveAddress() {
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;
      final address = data['address'];
      final city = data['city'];
      final state = data['state'];
      final zip = data['zip'];
      final addressForm =
          AddressForm(address: address, city: city, state: state, zipCode: zip);

      sl<AddressBloc>().add(AddressEvent.add(addressForm));
    }
  }
}
