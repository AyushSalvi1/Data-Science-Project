import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/common/utils/loading_dialog.dart';
import 'package:flutter_ecommerce/common/utils/toast_msg.dart';
import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/category/widgets/category_drop_down.dart';
import 'package:flutter_ecommerce/features/product/blocs/product_bloc/product_bloc.dart';
import 'package:flutter_ecommerce/features/product/models/product_form.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:logger/web.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images.map((e) => File(e.path)).toList());
        });
      }
    } catch (e) {
      if (mounted) AppToast.error(context, 'Failed to pick images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(24),
                _buildImages(),
                const Gap(24),
                _buildProductDetail(),
                _buildSaveButton(),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildSaveButton() {
    return SizedBox(
      width: double.maxFinite,
      height: 50,
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          state.whenOrNull(
              loading: () => AppProgressIndicator.show(context),
              loaded: (msg) {
                AppToast.success(context, msg);
                AppProgressIndicator.hide(context);
                context.pop();
              },
              failure: (failure) {
                AppToast.error(context, failure.toString());
                AppProgressIndicator.hide(context);
              });
        },
        builder: (context, state) {
          return state.maybeWhen(
              orElse: () => FilledButton(
                    onPressed: _onSaveProduct,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save Product",
                      style: TextStyle(fontSize: 16),
                    ),
                  ));
        },
      ),
    );
  }

  Column _buildProductDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Gap(16),
        FormBuilderTextField(
          name: 'productName',
          decoration: InputDecoration(
            labelText: 'Product Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(3),
          ]),
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                name: 'productPrice',
                decoration: InputDecoration(
                  labelText: 'Price',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ]),
              ),
            ),
            const Gap(16),
            Expanded(
              child: FormBuilderTextField(
                name: 'discountPrice',
                decoration: InputDecoration(
                  labelText: 'Discount Price',
                  prefixText: '\$ ',
                  hintText: 'Optional',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.numeric(checkNullOrEmpty: false),
                ]),
              ),
            ),
          ],
        ),
        const Gap(16),
        FormBuilderTextField(
          name: 'quantity',
          decoration: InputDecoration(
            labelText: 'Stock Quantity',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            // FormBuilderValidators.numeric(),
            FormBuilderValidators.integer(),
          ]),
        ),
        const Gap(16),
        const CategoryDropDown(),
        const Gap(16),
        FormBuilderTextField(
          name: 'productDescription',
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Product Description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(10),
          ]),
        ),
        const Gap(24),
      ],
    );
  }

  void _onSaveProduct() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      if (_selectedImages.isEmpty) {
        AppToast.error(context, 'Please select at least one image');
        return;
      }

      final productData = _formKey.currentState?.value;
      Logger().d(productData);
      final productName = productData!['productName'];
      final productPrice = productData['productPrice'];
      final productDescription = productData['productDescription'];
      final discountPrice = productData['discountPrice'];
      final categoryId = productData['categoryId'];
      final quantity = productData['quantity'];
      final productForm = ProductForm(
        name: productName,
        description: productDescription,
        price: double.parse(productPrice),
        imageFiles: _selectedImages,
        discountPrice:
            discountPrice != null ? double.tryParse(discountPrice) : null,
        quantity: int.parse(quantity),
        categoryId: categoryId,
      );

      sl<ProductBloc>().add(
        ProductEvent.add(productForm),
      );
    }
  }

  Column _buildImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Images',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Gap(8),
        if (_selectedImages.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImages[index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        const Gap(12),
        OutlinedButton.icon(
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Add Images'),
          onPressed: _pickImages,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
