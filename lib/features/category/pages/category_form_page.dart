import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/utils/loading_dialog.dart';
import 'package:flutter_ecommerce/common/utils/toast_msg.dart';
import 'package:flutter_ecommerce/common/widgets/custom_image_picker.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/category/blocs/category_bloc/category_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({super.key});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? _imageErrorMsg;
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Category",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Category Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(16),
                  FormBuilderTextField(
                    name: 'categoryName',
                    decoration: InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                      ],
                    ),
                  ),
                  const Gap(16),
                  CustomImagePicker(
                    errorMessage: _imageErrorMsg,
                    onImagePicked: (file) {
                      if (file != null) {
                        setState(() {
                          _imageFile = file;
                          _imageErrorMsg = null;
                        });
                      } else {
                        setState(() {
                          _imageFile = null;
                          _imageErrorMsg = 'Please select an image';
                        });
                      }
                    },
                  ),
                  if (_imageErrorMsg != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _imageErrorMsg!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  const Gap(24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: _buildCategorySaveBtn(),
      ),
    );
  }

  BlocConsumer<CategoryBloc, CategoryState> _buildCategorySaveBtn() {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: () {
            AppProgressIndicator.show(context);
          },
          loaded: (data) {
            AppToast.success(context, data);
            AppProgressIndicator.hide(context);
            context.pop();
          },
          failure: (failure) {
            AppProgressIndicator.hide(context);
            AppToast.error(context, failure.toString());
          },
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => SizedBox(
            width: double.infinity,
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                return FilledButton(
                  onPressed: _onSubmitCategory,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _onSubmitCategory() {
    setState(() {
      if (_imageFile == null) {
        _imageErrorMsg = 'Please select an image';
        return;
      }
    });
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final categoryName = _formKey.currentState!.value['categoryName'];
      sl<CategoryBloc>()
          .add(CategoryEvent.add(name: categoryName, imageFile: _imageFile!));
    }
  }
}
