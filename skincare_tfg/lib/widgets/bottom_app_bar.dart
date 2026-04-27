import '../screens/add_product_screen.dart';
import '../screens/my_products_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/routines_screen.dart';
import '../l10n/app_localizations.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;
  final Widget? child;
  final List<BottomNavigationBarItem>? items;
  final bool showLabels;

  const BottomNavBar({
    super.key,
    this.initialIndex = 0,
    this.child,
    this.items,
    this.showLabels = true,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _screens = const [
      HomeScreen(),
      MyProductsScreen(),
      AddProductScreen(),
      RoutinesScreen(),
      ProfileScreen(),
    ];
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;


    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.5);
    final borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.1);

    final defaultItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: l10n.home,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag_outlined),
        activeIcon: Icon(Icons.shopping_bag),
        label: l10n.products,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add),
        activeIcon: Icon(Icons.add),
        label: l10n.newTab,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.camera_alt_outlined),
        activeIcon: Icon(Icons.camera_alt),
        label: l10n.routines,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: l10n.profile,
      ),
    ];

    final body = widget.child ?? _screens[_currentIndex];

    return Scaffold(
      body: body,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: borderColor, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,

          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: unselectedColor,
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          showSelectedLabels: widget.showLabels,
          showUnselectedLabels: widget.showLabels,
          items: widget.items ?? defaultItems,
        ),
      ),
    );
  }
}