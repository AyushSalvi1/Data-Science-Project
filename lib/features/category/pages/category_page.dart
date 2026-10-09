import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce/features/category/blocs/get_category_bloc/get_category_bloc.dart';
import 'package:flutter_ecommerce/features/category/models/category.dart';
import 'package:flutter_ecommerce/features/category/widgets/category_card.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:go_router/go_router.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ).copyWith(bottom: 12, top: 4),
                child: Text(
                  "Shop by Categories",
                  style: TextTheme.of(context)
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            BlocBuilder<GetCategoryBloc, GetCategoryState>(
              builder: (context, state) {
                return state.maybeWhen(
                    loaded: (categories) => SliverList.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12)
                                .copyWith(bottom: 8),
                            child: CategoryCard(
                              onTap: () => _navigateToProductByCategoryPage(
                                  context, categories, index),
                              category: categories[index],
                            ),
                          ),
                          itemCount: categories.length,
                        ),
                    orElse: () => SizedBox());
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Object?> _navigateToProductByCategoryPage(
      BuildContext context, List<Category> categories, int index) {
    return context.pushNamed(AppRouteName.productByCategory,
        queryParameters: {"name": categories[index].name},
        pathParameters: {"id": categories[index].id.toString()});
  }
}
