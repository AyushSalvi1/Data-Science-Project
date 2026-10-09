import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/widgets/custom_cached_network_image.dart';
import 'package:flutter_ecommerce/features/category/models/category.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({
    super.key,
    required this.categories,
  });
  final List<Category> categories;
  @override

  Widget build(BuildContext context) {
    return Container(
      color: ColorScheme.of(context).surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: TextTheme.of(context)
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () => context.pushNamed(AppRouteName.categories),
                    child: Text("See All"))
              ],
            ),
            // Gap(12),
            LimitedBox(
              maxHeight: 140,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _navigateToProductByCategoryPage(
                      context,
                      categories,
                      index,
                    ),
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: SizedBox(
                            width: double.maxFinite,
                            child: AppCachedNetworkImage(
                              imageUrl: categories[index].imageUrl,
                              fit: BoxFit.cover,
                            ),
                          )),
                          Gap(8),
                          Center(
                            child: Text(
                              categories[index].name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextTheme.of(context).labelMedium,
                            ),
                          ),
                          Gap(8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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
