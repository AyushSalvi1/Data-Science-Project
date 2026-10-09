// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AppFormBuilderTextField extends StatelessWidget {
  const AppFormBuilderTextField({
    super.key,
    required this.name,
    required this.hintText,
    this.validator,
  });
  final String name;
  final String hintText;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(120)));
    return FormBuilderTextField(
        name: name,
        validator: validator,
        decoration: InputDecoration(
          fillColor:
              Theme.of(context).colorScheme.surfaceContainerLow.withAlpha(100),
          filled: true,
          hintText: hintText,
          border: border,
          focusedBorder: border.copyWith(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withAlpha(55))),
          enabledBorder: border.copyWith(
            borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withAlpha(55)),
          ),
        ));
  }
}
