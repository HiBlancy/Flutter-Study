import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Descomenta esto cuando añadas los textos a tus .arb

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mapa de categorías principales y sus subcategorías (las "pelotitas")
  // Nota: Estos textos los puedes pasar a tu archivo .arb más adelante
  final Map<String, List<Map<String, dynamic>>> _stashData = {
    'Facial': [
      {'name': 'Limpiador', 'icon': Icons.water_drop_outlined},
      {'name': 'Tónico', 'icon': Icons.opacity},
      {'name': 'Sérum', 'icon': Icons.science_outlined},
      {'name': 'Hidratante', 'icon': Icons.spa_outlined},
      {'name': 'Contorno', 'icon': Icons.visibility_outlined},
      {'name': 'Solar', 'icon': Icons.wb_sunny_outlined},
    ],
    'Corporal': [
      {'name': 'Gel', 'icon': Icons.shower_outlined},
      {'name': 'Exfoliante', 'icon': Icons.grain},
      {'name': 'Crema', 'icon': Icons.clean_hands_outlined},
      {'name': 'Manos', 'icon': Icons.front_hand_outlined},
      {'name': 'Desodorante', 'icon': Icons.air},
    ],
    'Capilar': [
      {'name': 'Champú', 'icon': Icons.wash_outlined},
      {'name': 'Acondicionador', 'icon': Icons.water_outlined},
      {'name': 'Mascarilla', 'icon': Icons.face_retouching_natural},
      {'name': 'Aceite', 'icon': Icons.liquor_outlined},
    ],
    'Maquillaje': [
      {'name': 'Base', 'icon': Icons.brush_outlined},
      {'name': 'Corrector', 'icon': Icons.edit_outlined},
      {'name': 'Ojos', 'icon': Icons.remove_red_eye_outlined},
      {'name': 'Labios', 'icon': Icons.face_4_outlined},
    ],
  };

  // Variable para recordar qué "pelotita" está seleccionada en cada pestaña
  final Map<String, String> _selectedSubcategories = {};

  @override
  void initState() {
    super.initState();
    // Seleccionar por defecto la primera pelotita de cada categoría
    _stashData.forEach((key, value) {
      if (value.isNotEmpty) {
        _selectedSubcategories[key] = value.first['name'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabs = _stashData.keys.toList();

    return DefaultTabController(
      length: tabs.length,
      child: CustomAppBar(
        title: 'Mi Tocador', // O l10n.myVanity
        showDrawer: true,
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Configuración',
          ),
        ],
        child: Column(
          children: [
            // 1. BARRA DE PESTAÑAS (Categorías Principales)
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                isScrollable: true, // Permite deslizar si hay muchas pestañas
                indicatorColor: theme.colorScheme.primary,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                labelStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                tabs: tabs.map((tab) => Tab(text: tab)).toList(),
              ),
            ),
            
            // 2. CONTENIDO DE CADA PESTAÑA
            Expanded(
              child: TabBarView(
                children: tabs.map((tab) {
                  return _buildTabContent(tab, theme);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String categoryName, ThemeData theme) {
    final subcategories = _stashData[categoryName] ?? [];
    final selectedSub = _selectedSubcategories[categoryName];

    return Column(
      children: [
        // SCROLL HORIZONTAL DE "PELOTITAS"
        Container(
          height: 110,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: subcategories.length,
            itemBuilder: (context, index) {
              final sub = subcategories[index];
              final isSelected = sub['name'] == selectedSub;
              
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSubcategories[categoryName] = sub['name'];
                    });
                  },
                  child: Column(
                    children: [
                      // La Pelotita
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                          border: Border.all(
                            color: isSelected 
                                ? theme.colorScheme.primary 
                                : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                            width: 2,
                          ),
                        ),
                        // NOTA: Aquí es donde podrás cambiar Icon() por Image.asset() o Image.network()
                        child: Icon(
                          sub['icon'] as IconData,
                          size: 28,
                          color: isSelected 
                              ? theme.colorScheme.onPrimary 
                              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // El Nombre debajo de la pelotita
                      Text(
                        sub['name'] as String,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        Divider(height: 1, color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
        
        // ZONA DE PRODUCTOS (Dependerá de la pelotita seleccionada)
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  subcategories.firstWhere((s) => s['name'] == selectedSub)['icon'] as IconData,
                  size: 64,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tus productos de $selectedSub',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aún no has categorizado ningún producto aquí',
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}