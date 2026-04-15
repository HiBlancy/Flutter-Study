// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'DueGlow';

  @override
  String helloUser(String name) {
    return '¡Hola $name!';
  }

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get createAcount => 'Crear Cuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get userEmailExample => 'usuario@ejemplo.com';

  @override
  String get enterEmailAddress => 'Ingrese su correo';

  @override
  String get invalidAddress => 'Correo inválido';

  @override
  String get password => 'Contraseña';

  @override
  String get enterPass => 'Ingrese su contraseña';

  @override
  String get pass6Char => 'Mínimo 6 caracteres';

  @override
  String get myProducts => 'Mis productos';

  @override
  String get seeAll => 'VER TODOS';

  @override
  String get routines => 'Rutinas';

  @override
  String get categories => 'Categorías';

  @override
  String get expiringSoon => 'Próximos a caducar';

  @override
  String get days => 'días';

  @override
  String get allFine => '¡Todo en orden!';

  @override
  String get noProdExpiring => 'No hay productos próximos a caducar';

  @override
  String get searchProducts => 'Buscar productos';

  @override
  String get searchNameBrand => 'Buscar por nombre o marca...';

  @override
  String get exmapleSearch => 'Ej: \"Yves Rocher\", \"hidratante\"';

  @override
  String get camera => 'Cámara';

  @override
  String get aimBarcode => 'Apunta al código de barras';

  @override
  String get settings => 'Configuración';

  @override
  String get general => 'General';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notifText => 'Recibir alertas y actualizaciones';

  @override
  String get appearance => 'Apariencia';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get information => 'Información';

  @override
  String get about => 'Acerca de';

  @override
  String get logout => 'Cerrar Sesión';
}
