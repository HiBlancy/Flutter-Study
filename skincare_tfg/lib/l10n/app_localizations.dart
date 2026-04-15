import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'DueGlow'**
  String get appName;

  /// Saludo en la pantalla de inicio
  ///
  /// In es, this message translates to:
  /// **'¡Hola {name}!'**
  String helloUser(String name);

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get login;

  /// No description provided for @createAcount.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get createAcount;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get email;

  /// No description provided for @userEmailExample.
  ///
  /// In es, this message translates to:
  /// **'usuario@ejemplo.com'**
  String get userEmailExample;

  /// No description provided for @enterEmailAddress.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su correo'**
  String get enterEmailAddress;

  /// No description provided for @invalidAddress.
  ///
  /// In es, this message translates to:
  /// **'Correo inválido'**
  String get invalidAddress;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @enterPass.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su contraseña'**
  String get enterPass;

  /// No description provided for @pass6Char.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get pass6Char;

  /// No description provided for @myProducts.
  ///
  /// In es, this message translates to:
  /// **'Mis productos'**
  String get myProducts;

  /// No description provided for @seeAll.
  ///
  /// In es, this message translates to:
  /// **'VER TODOS'**
  String get seeAll;

  /// No description provided for @routines.
  ///
  /// In es, this message translates to:
  /// **'Rutinas'**
  String get routines;

  /// No description provided for @categories.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categories;

  /// No description provided for @expiringSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximos a caducar'**
  String get expiringSoon;

  /// No description provided for @days.
  ///
  /// In es, this message translates to:
  /// **'días'**
  String get days;

  /// No description provided for @allFine.
  ///
  /// In es, this message translates to:
  /// **'¡Todo en orden!'**
  String get allFine;

  /// No description provided for @noProdExpiring.
  ///
  /// In es, this message translates to:
  /// **'No hay productos próximos a caducar'**
  String get noProdExpiring;

  /// No description provided for @searchProducts.
  ///
  /// In es, this message translates to:
  /// **'Buscar productos'**
  String get searchProducts;

  /// No description provided for @searchNameBrand.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre o marca...'**
  String get searchNameBrand;

  /// No description provided for @exmapleSearch.
  ///
  /// In es, this message translates to:
  /// **'Ej: \"Yves Rocher\", \"hidratante\"'**
  String get exmapleSearch;

  /// No description provided for @camera.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get camera;

  /// No description provided for @aimBarcode.
  ///
  /// In es, this message translates to:
  /// **'Apunta al código de barras'**
  String get aimBarcode;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @notifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifications;

  /// No description provided for @notifText.
  ///
  /// In es, this message translates to:
  /// **'Recibir alertas y actualizaciones'**
  String get notifText;

  /// No description provided for @appearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get appearance;

  /// No description provided for @lightMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Claro'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Oscuro'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @information.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get information;

  /// No description provided for @about.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
