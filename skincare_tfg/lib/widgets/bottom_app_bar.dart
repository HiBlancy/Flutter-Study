import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/scan_screen.dart';
import '../screens/profile_screen.dart';

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
      SearchScreen(),
      ScanScreen(),
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
    final defaultItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Inicio',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        activeIcon: Icon(Icons.search),
        label: 'Búsqueda',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.camera_alt_outlined),
        activeIcon: Icon(Icons.camera_alt),
        label: 'Cámara',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ];

    // Si se proporciona un child, usarlo, si no usar la navegación interna
    final body = widget.child ?? _screens[_currentIndex];

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: widget.showLabels,
        showUnselectedLabels: widget.showLabels,
        items: widget.items ?? defaultItems,
      ),
    );
  }
}