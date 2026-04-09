import 'package:dueglow/screens/add_product_screen.dart';
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
      AddProductScreen(),
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
    final theme = Theme.of(context);
    
    // Generamos los colores dinámicos basados en la opacidad del texto principal
    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.5);
    final borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.1);

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
        icon: Icon(Icons.add),
        activeIcon: Icon(Icons.add),
        label: 'Nuevo',
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

    final body = widget.child ?? _screens[_currentIndex];

    return Scaffold(
      body: body,
      // Envolvemos el BottomNavigationBar en un Container para añadir el borde sutil
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
          // Ya usa tu color magenta/ciruela automáticamente según el tema
          selectedItemColor: theme.colorScheme.primary, 
          unselectedItemColor: unselectedColor,
          backgroundColor: theme.colorScheme.surface,
          elevation: 0, // Quitamos la sombra gruesa a favor del borde superior
          showSelectedLabels: widget.showLabels,
          showUnselectedLabels: widget.showLabels,
          items: widget.items ?? defaultItems,
        ),
      ),
    );
  }
}