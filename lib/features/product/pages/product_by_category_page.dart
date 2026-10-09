// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_ecommerce/dependency_injection.dart';
import 'package:flutter_ecommerce/features/product/blocs/product_by_category_bloc/product_by_category_bloc.dart';
import 'package:flutter_ecommerce/features/product/widgets/no_product_found.dart';
import 'package:flutter_ecommerce/features/product/widgets/product_card.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class ProductByCategoryPage extends StatefulWidget {
  const ProductByCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });
  final String categoryId;
  final String? categoryName;
  @override
  State<ProductByCategoryPage> createState() => _ProductByCategoryPageState();
}

class _ProductByCategoryPageState extends State<ProductByCategoryPage> {
  final _productByCategoryBloc = sl<ProductByCategoryBloc>();
  @override
  void initState() {
    _productByCategoryBloc.add(ProductByCategoryEvent.get(widget.categoryId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName ?? "Products"),
        ),
        body: BlocBuilder<ProductByCategoryBloc, ProductByCategoryState>(
            bloc: _productByCategoryBloc,
            builder: (context, state) => state.when(
                  initial: () => SizedBox(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (products) => products.isEmpty
                      ? NoProductsFoundWidget()
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 250,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 8),
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () => context.pushNamed(
                                    AppRouteName.productDetailPage,
                                    pathParameters: {
                                      "id": products[index].id.toString()
                                    },
                                    extra: products[index]),
                                child: ProductCard(
                                  product: products[index],
                                ),
                              )),
                  failure: (failure) => Center(
                    child: Text(failure.toString()),
                  ),
                )));
  }
}
