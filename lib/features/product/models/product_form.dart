import 'dart:io';

class ProductForm {
  final String name;
  final String description;
  final double price;
  final List<File> imageFiles;
  final double? discountPrice;
  final int quantity;
  final String categoryId;
  ProductForm({
    required this.name,
    required this.description,
    required this.price,
    required this.imageFiles,
    required this.discountPrice,
    required this.quantity,
    required this.categoryId,
  });
}
