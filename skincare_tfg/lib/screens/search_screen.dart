import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'Buscar',
      showDrawer: true,
      showBackButton: false,
      child: const Center(
        child: Text(
          'Pantalla de búsqueda',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}