// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'DueGlow';

  @override
  String helloUser(String name) {
    return 'Hello $name!';
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
  String get myProducts => 'My products';

  @override
  String get seeAll => 'See all';

  @override
  String get routines => 'Routines';

  @override
  String get categories => 'Categories';

  @override
  String get expiringSoon => 'About to expire';

  @override
  String get days => 'days';

  @override
  String get allFine => 'All is fine!';

  @override
  String get noProdExpiring => 'No products are about to expire';

  @override
  String get searchProducts => 'Browse products';

  @override
  String get searchNameBrand => 'Search by name or brand...';

  @override
  String get exmapleSearch => 'Ex: \"Yves Rocher\", \"moisturising\"';

  @override
  String get camera => 'Camera';

  @override
  String get aimBarcode => 'Aim at the barcode';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get notifications => 'Notifications';

  @override
  String get notifText => 'Receive alerts and updates';

  @override
  String get appearance => 'Appearance';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get information => 'Information';

  @override
  String get about => 'About';

  @override
  String get logout => 'Log out';
}
