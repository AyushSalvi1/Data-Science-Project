import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/common/widgets/annotated_region_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatefulWidget {
  const LayoutScaffold({
    super.key,
    required this.shell,
  });
  final StatefulNavigationShell shell;
  @override
  State<LayoutScaffold> createState() => _LayoutScaffoldState();
}

class _LayoutScaffoldState extends State<LayoutScaffold> {
  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegion(
      child: Scaffold(
        body: widget.shell,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorScheme.of(context).surfaceContainerLowest,
          currentIndex: widget.shell.currentIndex,
          onTap: widget.shell.goBranch,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 12,
          selectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icons/home_filled.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                    ColorScheme.of(context).primary, BlendMode.srcIn),
              ),
              icon: SvgPicture.asset(
                'assets/icons/home_outline.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                    ColorScheme.of(context).onSurfaceVariant.withAlpha(160),
                    BlendMode.srcIn),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                    ColorScheme.of(context).primary, BlendMode.srcIn),
              ),
              icon: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                    ColorScheme.of(context).onSurfaceVariant.withAlpha(160),
                    BlendMode.srcIn),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.compare_arrows_rounded,
                size: 26,
                color: ColorScheme.of(context).primary,
              ),
              icon: Icon(
                Icons.compare_arrows_rounded,
                size: 26,
                color: ColorScheme.of(context).onSurfaceVariant.withAlpha(160),
              ),
              label: 'Compare',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icons/account_filled.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                    ColorScheme.of(context).primary, BlendMode.srcIn),
              ),
              icon: SvgPicture.asset(
                'assets/icons/account_outline.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                    ColorScheme.of(context).onSurfaceVariant.withAlpha(160),
                    BlendMode.srcIn),
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
