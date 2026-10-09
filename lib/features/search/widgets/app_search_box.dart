import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/features/visual_search/pages/visual_search_page.dart';
import 'package:flutter_ecommerce/routes.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AppSearchBoxUI extends StatelessWidget {
  const AppSearchBoxUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withAlpha(80),
          ),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () => context.goNamed(AppRouteName.search),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.search,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const Gap(12),
                  const Text(
                    "Search products or ask AI...",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                Icons.camera_alt_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              tooltip: "Image Visual Search",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VisualSearchPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
