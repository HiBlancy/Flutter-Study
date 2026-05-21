import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';

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
    Locale('ru'),
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

  /// No description provided for @pass8Char.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 8 caracteres'**
  String get pass8Char;

  /// No description provided for @strongPasswordHint.
  ///
  /// In es, this message translates to:
  /// **'Debe incluir mayúscula, minúscula, número y símbolo'**
  String get strongPasswordHint;

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

  /// No description provided for @expiredLabel.
  ///
  /// In es, this message translates to:
  /// **'Caducado'**
  String get expiredLabel;

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

  /// No description provided for @editProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get editProfile;

  /// No description provided for @phone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phone;

  /// No description provided for @phoneHint.
  ///
  /// In es, this message translates to:
  /// **'+34 123 456 789'**
  String get phoneHint;

  /// No description provided for @birthDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de nacimiento'**
  String get birthDate;

  /// No description provided for @birthDateHint.
  ///
  /// In es, this message translates to:
  /// **'DD/MM/AAAA'**
  String get birthDateHint;

  /// No description provided for @changePasswordOptional.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get changePasswordOptional;

  /// No description provided for @newPassword.
  ///
  /// In es, this message translates to:
  /// **'Nueva contraseña'**
  String get newPassword;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @selectBirthDate.
  ///
  /// In es, this message translates to:
  /// **'Selecciona tu fecha de nacimiento'**
  String get selectBirthDate;

  /// No description provided for @selectProfilePhotoTitle.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar foto de perfil'**
  String get selectProfilePhotoTitle;

  /// No description provided for @deletePhoto.
  ///
  /// In es, this message translates to:
  /// **'Eliminar foto'**
  String get deletePhoto;

  /// No description provided for @photoMarkedForDeletion.
  ///
  /// In es, this message translates to:
  /// **'Foto marcada para eliminar al guardar'**
  String get photoMarkedForDeletion;

  /// No description provided for @deletePhotoError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar la foto'**
  String get deletePhotoError;

  /// No description provided for @uploadPhotoError.
  ///
  /// In es, this message translates to:
  /// **'Error al subir la nueva foto'**
  String get uploadPhotoError;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado correctamente'**
  String get profileUpdatedSuccess;

  /// No description provided for @profileUpdateError.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar el perfil'**
  String get profileUpdateError;

  /// No description provided for @nextRoutineTitle.
  ///
  /// In es, this message translates to:
  /// **'Próxima rutina'**
  String get nextRoutineTitle;

  /// No description provided for @routinesTitle.
  ///
  /// In es, this message translates to:
  /// **'Rutinas'**
  String get routinesTitle;

  /// No description provided for @createFirstRoutineHomeHint.
  ///
  /// In es, this message translates to:
  /// **'Crea tu primera rutina para verla aquí.'**
  String get createFirstRoutineHomeHint;

  /// No description provided for @routineProductsCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{# producto} other{# productos}}'**
  String routineProductsCount(int count);

  /// No description provided for @slotTodayMorning.
  ///
  /// In es, this message translates to:
  /// **'Hoy mañana'**
  String get slotTodayMorning;

  /// No description provided for @slotTodayNight.
  ///
  /// In es, this message translates to:
  /// **'Hoy noche'**
  String get slotTodayNight;

  /// No description provided for @slotTomorrowMorning.
  ///
  /// In es, this message translates to:
  /// **'Mañana mañana'**
  String get slotTomorrowMorning;

  /// No description provided for @slotTomorrowNight.
  ///
  /// In es, this message translates to:
  /// **'Mañana noche'**
  String get slotTomorrowNight;

  /// No description provided for @slotInDaysMorning.
  ///
  /// In es, this message translates to:
  /// **'En {days} días (mañana)'**
  String slotInDaysMorning(int days);

  /// No description provided for @slotInDaysNight.
  ///
  /// In es, this message translates to:
  /// **'En {days} días (noche)'**
  String slotInDaysNight(int days);

  /// No description provided for @monthlyUsageTitle.
  ///
  /// In es, this message translates to:
  /// **'Uso mensual'**
  String get monthlyUsageTitle;

  /// No description provided for @monthlyUsageDescription.
  ///
  /// In es, this message translates to:
  /// **'Productos terminados en los ultimos meses.'**
  String get monthlyUsageDescription;

  /// No description provided for @thisMonthLabel.
  ///
  /// In es, this message translates to:
  /// **'Este mes'**
  String get thisMonthLabel;

  /// No description provided for @twelveMonthsLabel.
  ///
  /// In es, this message translates to:
  /// **'12 meses'**
  String get twelveMonthsLabel;

  /// No description provided for @noUsageHistory.
  ///
  /// In es, this message translates to:
  /// **'Aun no hay historial de productos usados.'**
  String get noUsageHistory;

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

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @clear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clear;

  /// No description provided for @filterAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get filterAll;

  /// No description provided for @filterOpened.
  ///
  /// In es, this message translates to:
  /// **'Abiertos'**
  String get filterOpened;

  /// No description provided for @filterExpired.
  ///
  /// In es, this message translates to:
  /// **'Caducados'**
  String get filterExpired;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @russian.
  ///
  /// In es, this message translates to:
  /// **'Ruso'**
  String get russian;

  /// No description provided for @versionLabel.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String versionLabel(String version);

  /// No description provided for @notificationsEnabled.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones activadas'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones desactivadas'**
  String get notificationsDisabled;

  /// No description provided for @allProducts.
  ///
  /// In es, this message translates to:
  /// **'Todos los productos'**
  String get allProducts;

  /// No description provided for @noProductsRegistered.
  ///
  /// In es, this message translates to:
  /// **'No tienes productos registrados'**
  String get noProductsRegistered;

  /// No description provided for @noProductsInHave.
  ///
  /// In es, this message translates to:
  /// **'No tienes productos en \"Tengo\"'**
  String get noProductsInHave;

  /// No description provided for @noProductsInWishlist.
  ///
  /// In es, this message translates to:
  /// **'No tienes productos en \"Deseados\"'**
  String get noProductsInWishlist;

  /// No description provided for @noFinishedProducts.
  ///
  /// In es, this message translates to:
  /// **'No has registrado productos terminados'**
  String get noFinishedProducts;

  /// No description provided for @addFirstProductsHint.
  ///
  /// In es, this message translates to:
  /// **'Agrega tus primeros productos escaneando códigos de barras o buscando en la base de datos'**
  String get addFirstProductsHint;

  /// No description provided for @haveProductsHint.
  ///
  /// In es, this message translates to:
  /// **'Los productos que marques como \"Tengo\" aparecerán aquí'**
  String get haveProductsHint;

  /// No description provided for @wishlistProductsHint.
  ///
  /// In es, this message translates to:
  /// **'Agrega productos a tu wishlist desde la pantalla de detalles'**
  String get wishlistProductsHint;

  /// No description provided for @usedProductsHint.
  ///
  /// In es, this message translates to:
  /// **'Los productos que has acabado este mes aparecen en esta lista'**
  String get usedProductsHint;

  /// No description provided for @usedProductsInfo.
  ///
  /// In es, this message translates to:
  /// **'Estos son los productos que has terminado este mes. Cuando termine el mes, estos productos se eliminarán automáticamente y se almacenarán los datos para el proyecto PAN.'**
  String get usedProductsInfo;

  /// No description provided for @productsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} producto{pluralSuffix}'**
  String productsCount(int count, String pluralSuffix);

  /// No description provided for @searchLoading.
  ///
  /// In es, this message translates to:
  /// **'Buscando...'**
  String get searchLoading;

  /// No description provided for @searchErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'Error al buscar'**
  String get searchErrorTitle;

  /// No description provided for @searchConnectionError.
  ///
  /// In es, this message translates to:
  /// **'Error al buscar. Revisa tu conexión.'**
  String get searchConnectionError;

  /// No description provided for @searchNoResults.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron productos'**
  String get searchNoResults;

  /// No description provided for @searchTryAnotherTerm.
  ///
  /// In es, this message translates to:
  /// **'Prueba con otro término de búsqueda'**
  String get searchTryAnotherTerm;

  /// No description provided for @searchBeautyProducts.
  ///
  /// In es, this message translates to:
  /// **'Busca productos de belleza'**
  String get searchBeautyProducts;

  /// No description provided for @searchExamplesExtended.
  ///
  /// In es, this message translates to:
  /// **'Ej: \"L\'Oréal\", \"hidratante\", \"champú\"'**
  String get searchExamplesExtended;

  /// No description provided for @noBrand.
  ///
  /// In es, this message translates to:
  /// **'Sin marca'**
  String get noBrand;

  /// No description provided for @scanProductNotFound.
  ///
  /// In es, this message translates to:
  /// **'Producto no encontrado'**
  String get scanProductNotFound;

  /// No description provided for @scanNoBarcodeInfo.
  ///
  /// In es, this message translates to:
  /// **'No se encontró información para el código de barras:\n{barcode}\n\n¿Quieres crear un nuevo producto manualmente?'**
  String scanNoBarcodeInfo(String barcode);

  /// No description provided for @createProduct.
  ///
  /// In es, this message translates to:
  /// **'Crear producto'**
  String get createProduct;

  /// No description provided for @newProductDefaultName.
  ///
  /// In es, this message translates to:
  /// **'Nuevo producto'**
  String get newProductDefaultName;

  /// No description provided for @deleteRoutineTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar rutina'**
  String get deleteRoutineTitle;

  /// No description provided for @deleteRoutineQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar \"{name}\"?'**
  String deleteRoutineQuestion(String name);

  /// No description provided for @routineDeleted.
  ///
  /// In es, this message translates to:
  /// **'Rutina eliminada'**
  String get routineDeleted;

  /// No description provided for @routinesLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar rutinas'**
  String get routinesLoadError;

  /// No description provided for @routineDeleteError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar rutina'**
  String get routineDeleteError;

  /// No description provided for @morning.
  ///
  /// In es, this message translates to:
  /// **'Mañana'**
  String get morning;

  /// No description provided for @night.
  ///
  /// In es, this message translates to:
  /// **'Noche'**
  String get night;

  /// No description provided for @newRoutine.
  ///
  /// In es, this message translates to:
  /// **'Nueva rutina'**
  String get newRoutine;

  /// No description provided for @noMorningRoutines.
  ///
  /// In es, this message translates to:
  /// **'Sin rutinas de mañana'**
  String get noMorningRoutines;

  /// No description provided for @noNightRoutines.
  ///
  /// In es, this message translates to:
  /// **'Sin rutinas de noche'**
  String get noNightRoutines;

  /// No description provided for @createFirstRoutineHint.
  ///
  /// In es, this message translates to:
  /// **'Crea tu primera rutina de {period}\ny organiza tus productos de skincare'**
  String createFirstRoutineHint(String period);

  /// No description provided for @createRoutine.
  ///
  /// In es, this message translates to:
  /// **'Crear rutina'**
  String get createRoutine;

  /// No description provided for @selectAtLeastOneDay.
  ///
  /// In es, this message translates to:
  /// **'Selecciona al menos 1 día'**
  String get selectAtLeastOneDay;

  /// No description provided for @routineCreatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'✓ Rutina creada correctamente'**
  String get routineCreatedSuccess;

  /// No description provided for @routineCreateError.
  ///
  /// In es, this message translates to:
  /// **'Error al crear la rutina'**
  String get routineCreateError;

  /// No description provided for @routineNameRequiredLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la rutina *'**
  String get routineNameRequiredLabel;

  /// No description provided for @routineNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Rutina de mañana'**
  String get routineNameHint;

  /// No description provided for @requiredField.
  ///
  /// In es, this message translates to:
  /// **'Obligatorio'**
  String get requiredField;

  /// No description provided for @routineType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de rutina'**
  String get routineType;

  /// No description provided for @weekDays.
  ///
  /// In es, this message translates to:
  /// **'Días de la semana'**
  String get weekDays;

  /// No description provided for @none.
  ///
  /// In es, this message translates to:
  /// **'Ninguno'**
  String get none;

  /// No description provided for @all.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @addProduct.
  ///
  /// In es, this message translates to:
  /// **'Añadir producto'**
  String get addProduct;

  /// No description provided for @noMoreProductsToAdd.
  ///
  /// In es, this message translates to:
  /// **'No hay más productos\npara añadir'**
  String get noMoreProductsToAdd;

  /// No description provided for @routineNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get routineNameLabel;

  /// No description provided for @morningRoutineLabel.
  ///
  /// In es, this message translates to:
  /// **'Rutina de mañana'**
  String get morningRoutineLabel;

  /// No description provided for @nightRoutineLabel.
  ///
  /// In es, this message translates to:
  /// **'Rutina de noche'**
  String get nightRoutineLabel;

  /// No description provided for @products.
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get products;

  /// No description provided for @noProductAdded.
  ///
  /// In es, this message translates to:
  /// **'Ningún producto añadido'**
  String get noProductAdded;

  /// No description provided for @longPressReorder.
  ///
  /// In es, this message translates to:
  /// **'Mantén pulsado para reordenar'**
  String get longPressReorder;

  /// No description provided for @noProductsYet.
  ///
  /// In es, this message translates to:
  /// **'Sin productos aún'**
  String get noProductsYet;

  /// No description provided for @addProductsToBuildRoutine.
  ///
  /// In es, this message translates to:
  /// **'Añade productos de tu armario\npara construir tu rutina'**
  String get addProductsToBuildRoutine;

  /// No description provided for @routineUpdated.
  ///
  /// In es, this message translates to:
  /// **'Rutina actualizada'**
  String get routineUpdated;

  /// No description provided for @updateError.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar'**
  String get updateError;

  /// No description provided for @productRemovedFromRoutine.
  ///
  /// In es, this message translates to:
  /// **'Producto eliminado de la rutina'**
  String get productRemovedFromRoutine;

  /// No description provided for @productRemoveError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar producto'**
  String get productRemoveError;

  /// No description provided for @reorderProductsError.
  ///
  /// In es, this message translates to:
  /// **'Error al reordenar productos'**
  String get reorderProductsError;

  /// No description provided for @productAddedToRoutine.
  ///
  /// In es, this message translates to:
  /// **'Producto añadido a la rutina'**
  String get productAddedToRoutine;

  /// No description provided for @productAddError.
  ///
  /// In es, this message translates to:
  /// **'Error al añadir producto'**
  String get productAddError;

  /// No description provided for @addToRoutine.
  ///
  /// In es, this message translates to:
  /// **'Añadir a rutina'**
  String get addToRoutine;

  /// No description provided for @productAlreadyInRoutine.
  ///
  /// In es, this message translates to:
  /// **'Este producto ya está añadido a esta rutina.'**
  String get productAlreadyInRoutine;

  /// No description provided for @productAddedToRoutineNamed.
  ///
  /// In es, this message translates to:
  /// **'Producto añadido a la rutina: {routineName}'**
  String productAddedToRoutineNamed(String routineName);

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @newTab.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get newTab;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @aboutDescription.
  ///
  /// In es, this message translates to:
  /// **'DueGlow es una app para organizar productos de belleza, controlar fechas de caducidad y crear rutinas de cuidado personal.\n\nEste proyecto fue creado como Trabajo de Fin de Grado (TFG) del ciclo de Desarrollo de Aplicaciones Multiplataforma (DAM).\n\nObjetivo: ayudar a mantener hábitos de autocuidado de forma simple, práctica y visual.'**
  String get aboutDescription;

  /// No description provided for @vanity.
  ///
  /// In es, this message translates to:
  /// **'Mi Tocador'**
  String get vanity;

  /// No description provided for @yourProductsOf.
  ///
  /// In es, this message translates to:
  /// **'Tus productos de {subcategory}'**
  String yourProductsOf(String subcategory);

  /// No description provided for @noCategorizedProductsSection.
  ///
  /// In es, this message translates to:
  /// **'Aún no has categorizado ningún producto en esta sección.\nAgrega productos desde tu inventario para verlos ordenados por sección.'**
  String get noCategorizedProductsSection;

  /// No description provided for @featureInDevelopment.
  ///
  /// In es, this message translates to:
  /// **'Funcionalidad en desarrollo'**
  String get featureInDevelopment;

  /// No description provided for @defaultUserName.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get defaultUserName;

  /// No description provided for @morningGreeting.
  ///
  /// In es, this message translates to:
  /// **'Buenos días, {name}'**
  String morningGreeting(String name);

  /// No description provided for @afternoonGreeting.
  ///
  /// In es, this message translates to:
  /// **'Buenas tardes, {name}'**
  String afternoonGreeting(String name);

  /// No description provided for @eveningGreeting.
  ///
  /// In es, this message translates to:
  /// **'Buenas noches, {name}'**
  String eveningGreeting(String name);

  /// No description provided for @skinGlowTagline.
  ///
  /// In es, this message translates to:
  /// **'Que tu piel nunca deje de brillar'**
  String get skinGlowTagline;

  /// No description provided for @prioritizeExpiringHint.
  ///
  /// In es, this message translates to:
  /// **'Prioriza estos productos antes de que caduquen'**
  String get prioritizeExpiringHint;

  /// No description provided for @errorTitle.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @accept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get accept;

  /// No description provided for @invalidUserOrPassword.
  ///
  /// In es, this message translates to:
  /// **'Usuario o contraseña incorrectos'**
  String get invalidUserOrPassword;

  /// No description provided for @exitAppTitle.
  ///
  /// In es, this message translates to:
  /// **'Salir de la app'**
  String get exitAppTitle;

  /// No description provided for @exitAppQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Quieres salir de la aplicación?'**
  String get exitAppQuestion;

  /// No description provided for @exit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get exit;

  /// No description provided for @forgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// No description provided for @comingSoon.
  ///
  /// In es, this message translates to:
  /// **'Función próximamente disponible'**
  String get comingSoon;

  /// No description provided for @loginButtonUpper.
  ///
  /// In es, this message translates to:
  /// **'INICIAR SESIÓN'**
  String get loginButtonUpper;

  /// No description provided for @dontHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta?'**
  String get dontHaveAccount;

  /// No description provided for @createOne.
  ///
  /// In es, this message translates to:
  /// **'Crear una'**
  String get createOne;

  /// No description provided for @orContinueWith.
  ///
  /// In es, this message translates to:
  /// **'O continuar con'**
  String get orContinueWith;

  /// No description provided for @fullName.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get fullName;

  /// No description provided for @userNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de usuario'**
  String get userNameLabel;

  /// No description provided for @enterName.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su nombre'**
  String get enterName;

  /// No description provided for @min3Chars.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 3 caracteres'**
  String get min3Chars;

  /// No description provided for @confirmPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirme su contraseña'**
  String get confirmYourPassword;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsDontMatch;

  /// No description provided for @mustAcceptTerms.
  ///
  /// In es, this message translates to:
  /// **'Debes aceptar los términos y condiciones'**
  String get mustAcceptTerms;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Cuenta creada exitosamente!'**
  String get accountCreatedSuccess;

  /// No description provided for @createAccountErrorMaybeEmail.
  ///
  /// In es, this message translates to:
  /// **'Error al crear la cuenta. El correo podría estar registrado.'**
  String get createAccountErrorMaybeEmail;

  /// No description provided for @startManagingProducts.
  ///
  /// In es, this message translates to:
  /// **'Empieza a gestionar tus productos'**
  String get startManagingProducts;

  /// No description provided for @acceptTermsPrefix.
  ///
  /// In es, this message translates to:
  /// **'Acepto los '**
  String get acceptTermsPrefix;

  /// No description provided for @termsAndConditions.
  ///
  /// In es, this message translates to:
  /// **'términos y condiciones'**
  String get termsAndConditions;

  /// No description provided for @andThe.
  ///
  /// In es, this message translates to:
  /// **' y la '**
  String get andThe;

  /// No description provided for @privacyPolicy.
  ///
  /// In es, this message translates to:
  /// **'política de privacidad'**
  String get privacyPolicy;

  /// No description provided for @createAccountUpper.
  ///
  /// In es, this message translates to:
  /// **'CREAR CUENTA'**
  String get createAccountUpper;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes una cuenta?'**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión'**
  String get signIn;

  /// No description provided for @addProductTitle.
  ///
  /// In es, this message translates to:
  /// **'Añadir Producto'**
  String get addProductTitle;

  /// No description provided for @scanAction.
  ///
  /// In es, this message translates to:
  /// **'Escanear'**
  String get scanAction;

  /// No description provided for @barcodeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Código de barras'**
  String get barcodeSubtitle;

  /// No description provided for @searchAction.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get searchAction;

  /// No description provided for @onlineProductSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Producto online'**
  String get onlineProductSubtitle;

  /// No description provided for @orAddManuallyUpper.
  ///
  /// In es, this message translates to:
  /// **'O AÑADE MANUALMENTE'**
  String get orAddManuallyUpper;

  /// No description provided for @productNameRequiredLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del producto *'**
  String get productNameRequiredLabel;

  /// No description provided for @productNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Crema Hidratante'**
  String get productNameHint;

  /// No description provided for @brand.
  ///
  /// In es, this message translates to:
  /// **'Marca'**
  String get brand;

  /// No description provided for @brandRequiredLabel.
  ///
  /// In es, this message translates to:
  /// **'Marca *'**
  String get brandRequiredLabel;

  /// No description provided for @brandHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Nivea'**
  String get brandHint;

  /// No description provided for @expiresLabel.
  ///
  /// In es, this message translates to:
  /// **'Caduca: {date}'**
  String expiresLabel(String date);

  /// No description provided for @expirationDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de caducidad'**
  String get expirationDate;

  /// No description provided for @saveInMyVanity.
  ///
  /// In es, this message translates to:
  /// **'Guardar en mi tocador'**
  String get saveInMyVanity;

  /// No description provided for @productImage.
  ///
  /// In es, this message translates to:
  /// **'Imagen del producto'**
  String get productImage;

  /// No description provided for @tapToAddImage.
  ///
  /// In es, this message translates to:
  /// **'Toca para añadir imagen'**
  String get tapToAddImage;

  /// No description provided for @addProductImageTitle.
  ///
  /// In es, this message translates to:
  /// **'Añadir imagen del producto'**
  String get addProductImageTitle;

  /// No description provided for @takePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar de galería'**
  String get chooseFromGallery;

  /// No description provided for @deleteImage.
  ///
  /// In es, this message translates to:
  /// **'Eliminar imagen'**
  String get deleteImage;

  /// No description provided for @imageDeleted.
  ///
  /// In es, this message translates to:
  /// **'Imagen eliminada'**
  String get imageDeleted;

  /// No description provided for @imageCapturedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Imagen capturada correctamente'**
  String get imageCapturedSuccess;

  /// No description provided for @imageCaptureError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo capturar la imagen'**
  String get imageCaptureError;

  /// No description provided for @imageSelectedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Imagen seleccionada correctamente'**
  String get imageSelectedSuccess;

  /// No description provided for @imageSelectError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo seleccionar la imagen'**
  String get imageSelectError;

  /// No description provided for @productSavedImageUploadFailed.
  ///
  /// In es, this message translates to:
  /// **'Producto guardado pero la imagen no se pudo subir'**
  String get productSavedImageUploadFailed;

  /// No description provided for @productAddedSuccess.
  ///
  /// In es, this message translates to:
  /// **'✓ Producto añadido correctamente'**
  String get productAddedSuccess;

  /// No description provided for @saveProductError.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar el producto'**
  String get saveProductError;

  /// No description provided for @paoDuration.
  ///
  /// In es, this message translates to:
  /// **'Duración tras abrir (PAO)'**
  String get paoDuration;

  /// No description provided for @periodAfterOpening.
  ///
  /// In es, this message translates to:
  /// **'Periodo después de la apertura'**
  String get periodAfterOpening;

  /// No description provided for @findOpenJarIcon.
  ///
  /// In es, this message translates to:
  /// **'Busca el icono del tarro abierto en el envase'**
  String get findOpenJarIcon;

  /// No description provided for @customPaoHint.
  ///
  /// In es, this message translates to:
  /// **'O escribe uno personalizado (ej: 9M)'**
  String get customPaoHint;

  /// No description provided for @category.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// No description provided for @categoryHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Facial'**
  String get categoryHint;

  /// No description provided for @errorPerformingOperation.
  ///
  /// In es, this message translates to:
  /// **'Error al realizar la operación'**
  String get errorPerformingOperation;

  /// No description provided for @changeToAnotherList.
  ///
  /// In es, this message translates to:
  /// **'Cambiar a otra lista'**
  String get changeToAnotherList;

  /// No description provided for @productMovedToList.
  ///
  /// In es, this message translates to:
  /// **'✓ Producto movido a \"{list}\"'**
  String productMovedToList(String list);

  /// No description provided for @addProductQuestionTitle.
  ///
  /// In es, this message translates to:
  /// **'Agregar producto'**
  String get addProductQuestionTitle;

  /// No description provided for @addProductQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Quieres agregar \"{name}\" a tu lista de productos?'**
  String addProductQuestion(String name);

  /// No description provided for @productAddedToList.
  ///
  /// In es, this message translates to:
  /// **'✓ \"{name}\" agregado a tu lista'**
  String productAddedToList(String name);

  /// No description provided for @productUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'✓ Producto actualizado correctamente'**
  String get productUpdatedSuccess;

  /// No description provided for @deleteProductTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar producto'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar \"{name}\" de tu lista?'**
  String deleteProductQuestion(String name);

  /// No description provided for @productDeletedFromList.
  ///
  /// In es, this message translates to:
  /// **'✓ \"{name}\" eliminado de tu lista'**
  String productDeletedFromList(String name);

  /// No description provided for @deleteProductError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar el producto'**
  String get deleteProductError;

  /// No description provided for @markAsFinishedTitle.
  ///
  /// In es, this message translates to:
  /// **'Marcar como terminado'**
  String get markAsFinishedTitle;

  /// No description provided for @markAsFinishedQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que has terminado \"{name}\"?\n\nEl producto se moverá a la lista de terminados y se registrará en tu historial mensual.'**
  String markAsFinishedQuestion(String name);

  /// No description provided for @productMarkedFinished.
  ///
  /// In es, this message translates to:
  /// **'✓ \"{name}\" marcado como terminado'**
  String productMarkedFinished(String name);

  /// No description provided for @openProduct.
  ///
  /// In es, this message translates to:
  /// **'Abrir producto'**
  String get openProduct;

  /// No description provided for @today.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get today;

  /// No description provided for @anotherDate.
  ///
  /// In es, this message translates to:
  /// **'Otra fecha...'**
  String get anotherDate;

  /// No description provided for @productMarkedOpened.
  ///
  /// In es, this message translates to:
  /// **'✓ Producto marcado como abierto'**
  String get productMarkedOpened;

  /// No description provided for @productMarkedClosed.
  ///
  /// In es, this message translates to:
  /// **'✓ Producto marcado como cerrado'**
  String get productMarkedClosed;

  /// No description provided for @expirationCalculated.
  ///
  /// In es, this message translates to:
  /// **'✓ Fecha de caducidad calculada'**
  String get expirationCalculated;

  /// No description provided for @editProductTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar producto'**
  String get editProductTooltip;

  /// No description provided for @deleteProduct.
  ///
  /// In es, this message translates to:
  /// **'Eliminar producto'**
  String get deleteProduct;

  /// No description provided for @currentList.
  ///
  /// In es, this message translates to:
  /// **'Lista actual'**
  String get currentList;

  /// No description provided for @changeListTooltip.
  ///
  /// In es, this message translates to:
  /// **'Cambiar lista'**
  String get changeListTooltip;

  /// No description provided for @addedLabel.
  ///
  /// In es, this message translates to:
  /// **'Agregado'**
  String get addedLabel;

  /// No description provided for @expirationLabel.
  ///
  /// In es, this message translates to:
  /// **'Caducidad'**
  String get expirationLabel;

  /// No description provided for @openedOnLabel.
  ///
  /// In es, this message translates to:
  /// **'Abierto el'**
  String get openedOnLabel;

  /// No description provided for @notes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get notes;

  /// No description provided for @noExpirationInfoWarningTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin información de caducidad'**
  String get noExpirationInfoWarningTitle;

  /// No description provided for @noExpirationInfoWarningBody.
  ///
  /// In es, this message translates to:
  /// **'Edita el producto para añadir su duración después de abierto (ej: \"6M\") o una fecha de caducidad.'**
  String get noExpirationInfoWarningBody;

  /// No description provided for @addToMyProducts.
  ///
  /// In es, this message translates to:
  /// **'Agregar a mis productos'**
  String get addToMyProducts;

  /// No description provided for @closeProduct.
  ///
  /// In es, this message translates to:
  /// **'Cerrar producto'**
  String get closeProduct;

  /// No description provided for @calculateExpiration.
  ///
  /// In es, this message translates to:
  /// **'Calcular caducidad'**
  String get calculateExpiration;

  /// No description provided for @finishedProduct.
  ///
  /// In es, this message translates to:
  /// **'Producto acabado'**
  String get finishedProduct;

  /// No description provided for @editProduct.
  ///
  /// In es, this message translates to:
  /// **'Editar producto'**
  String get editProduct;

  /// No description provided for @list.
  ///
  /// In es, this message translates to:
  /// **'Lista'**
  String get list;

  /// No description provided for @rating.
  ///
  /// In es, this message translates to:
  /// **'Calificación'**
  String get rating;

  /// No description provided for @deleteAll.
  ///
  /// In es, this message translates to:
  /// **'Eliminar todas'**
  String get deleteAll;

  /// No description provided for @newCategory.
  ///
  /// In es, this message translates to:
  /// **'Nueva categoría'**
  String get newCategory;

  /// No description provided for @uploadingImage.
  ///
  /// In es, this message translates to:
  /// **'Subiendo imagen...'**
  String get uploadingImage;

  /// No description provided for @changeProductImageTitle.
  ///
  /// In es, this message translates to:
  /// **'Cambiar imagen del producto'**
  String get changeProductImageTitle;

  /// No description provided for @imageDeletedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Imagen eliminada correctamente'**
  String get imageDeletedSuccess;

  /// No description provided for @deleteImageError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar la imagen'**
  String get deleteImageError;

  /// No description provided for @nameRequiredError.
  ///
  /// In es, this message translates to:
  /// **'El nombre es obligatorio'**
  String get nameRequiredError;

  /// No description provided for @brandRequiredError.
  ///
  /// In es, this message translates to:
  /// **'La marca es obligatoria'**
  String get brandRequiredError;

  /// No description provided for @imageUploadError.
  ///
  /// In es, this message translates to:
  /// **'Error al subir la imagen'**
  String get imageUploadError;

  /// No description provided for @saveChangesError.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar los cambios'**
  String get saveChangesError;

  /// No description provided for @expirationWithDate.
  ///
  /// In es, this message translates to:
  /// **'Caducidad: {date}'**
  String expirationWithDate(String date);

  /// No description provided for @addExpirationDate.
  ///
  /// In es, this message translates to:
  /// **'Añadir fecha de caducidad'**
  String get addExpirationDate;

  /// No description provided for @additionalNotes.
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales'**
  String get additionalNotes;

  /// No description provided for @deleteDateTooltip.
  ///
  /// In es, this message translates to:
  /// **'Eliminar fecha'**
  String get deleteDateTooltip;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @selectCategoriesTitle.
  ///
  /// In es, this message translates to:
  /// **'Selecciona categorías'**
  String get selectCategoriesTitle;

  /// No description provided for @chooseCategories.
  ///
  /// In es, this message translates to:
  /// **'Elegir categorías'**
  String get chooseCategories;

  /// No description provided for @saveCategorySelection.
  ///
  /// In es, this message translates to:
  /// **'Guardar selección'**
  String get saveCategorySelection;

  /// No description provided for @sectionFacial.
  ///
  /// In es, this message translates to:
  /// **'Facial'**
  String get sectionFacial;

  /// No description provided for @sectionCorporal.
  ///
  /// In es, this message translates to:
  /// **'Corporal'**
  String get sectionCorporal;

  /// No description provided for @sectionCapilar.
  ///
  /// In es, this message translates to:
  /// **'Capilar'**
  String get sectionCapilar;

  /// No description provided for @sectionMaquillaje.
  ///
  /// In es, this message translates to:
  /// **'Maquillaje'**
  String get sectionMaquillaje;

  /// No description provided for @sectionMedicamentosSuplementos.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos y suplementos'**
  String get sectionMedicamentosSuplementos;

  /// No description provided for @sectionOtros.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get sectionOtros;

  /// No description provided for @subLimpieza.
  ///
  /// In es, this message translates to:
  /// **'Limpieza'**
  String get subLimpieza;

  /// No description provided for @subSerums.
  ///
  /// In es, this message translates to:
  /// **'Sérums'**
  String get subSerums;

  /// No description provided for @subCremas.
  ///
  /// In es, this message translates to:
  /// **'Cremas'**
  String get subCremas;

  /// No description provided for @subContornoOjos.
  ///
  /// In es, this message translates to:
  /// **'Contorno de ojos'**
  String get subContornoOjos;

  /// No description provided for @subTratamientos.
  ///
  /// In es, this message translates to:
  /// **'Tratamientos'**
  String get subTratamientos;

  /// No description provided for @subProteccion.
  ///
  /// In es, this message translates to:
  /// **'Protección'**
  String get subProteccion;

  /// No description provided for @subGel.
  ///
  /// In es, this message translates to:
  /// **'Gel'**
  String get subGel;

  /// No description provided for @subCrema.
  ///
  /// In es, this message translates to:
  /// **'Crema'**
  String get subCrema;

  /// No description provided for @subManos.
  ///
  /// In es, this message translates to:
  /// **'Manos'**
  String get subManos;

  /// No description provided for @subDesodorante.
  ///
  /// In es, this message translates to:
  /// **'Desodorante'**
  String get subDesodorante;

  /// No description provided for @subChampu.
  ///
  /// In es, this message translates to:
  /// **'Champú'**
  String get subChampu;

  /// No description provided for @subMascarilla.
  ///
  /// In es, this message translates to:
  /// **'Mascarilla'**
  String get subMascarilla;

  /// No description provided for @subAcondicionador.
  ///
  /// In es, this message translates to:
  /// **'Acondicionador'**
  String get subAcondicionador;

  /// No description provided for @subSerumCapilar.
  ///
  /// In es, this message translates to:
  /// **'Sérum capilar'**
  String get subSerumCapilar;

  /// No description provided for @subRostro.
  ///
  /// In es, this message translates to:
  /// **'Rostro'**
  String get subRostro;

  /// No description provided for @subOjos.
  ///
  /// In es, this message translates to:
  /// **'Ojos'**
  String get subOjos;

  /// No description provided for @subLabios.
  ///
  /// In es, this message translates to:
  /// **'Labios'**
  String get subLabios;

  /// No description provided for @subCejas.
  ///
  /// In es, this message translates to:
  /// **'Cejas'**
  String get subCejas;

  /// No description provided for @subMedicamentos.
  ///
  /// In es, this message translates to:
  /// **'Medicamentos'**
  String get subMedicamentos;

  /// No description provided for @subSuplementos.
  ///
  /// In es, this message translates to:
  /// **'Suplementos'**
  String get subSuplementos;

  /// No description provided for @subUnas.
  ///
  /// In es, this message translates to:
  /// **'Uñas'**
  String get subUnas;

  /// No description provided for @subFragancia.
  ///
  /// In es, this message translates to:
  /// **'Fragancia'**
  String get subFragancia;

  /// No description provided for @subCacaoLabial.
  ///
  /// In es, this message translates to:
  /// **'Cacao de labios'**
  String get subCacaoLabial;

  /// No description provided for @subHigieneIntima.
  ///
  /// In es, this message translates to:
  /// **'Higiene íntima'**
  String get subHigieneIntima;

  /// No description provided for @subSolaresCorporales.
  ///
  /// In es, this message translates to:
  /// **'Solares corporales'**
  String get subSolaresCorporales;

  /// No description provided for @subOtros.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get subOtros;

  /// No description provided for @deleteAccountSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get deleteAccountSectionTitle;

  /// No description provided for @deleteAccount.
  ///
  /// In es, this message translates to:
  /// **'Borrar cuenta'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Acción permanente e irreversible'**
  String get deleteAccountSubtitle;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Borrar tu cuenta?'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogMessage.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer. Perderás todo de forma permanente: productos, rutinas, imágenes y cualquier dato asociado a tu cuenta.\n\nConfirma solo si estás seguro.'**
  String get deleteAccountDialogMessage;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In es, this message translates to:
  /// **'Sí, borrar mi cuenta'**
  String get deleteAccountConfirmButton;

  /// No description provided for @deleteAccountDeleting.
  ///
  /// In es, this message translates to:
  /// **'Borrando cuenta…'**
  String get deleteAccountDeleting;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In es, this message translates to:
  /// **'Cuenta eliminada. Se ha cerrado la sesión.'**
  String get deleteAccountSuccess;

  /// No description provided for @deleteAccountError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo borrar la cuenta. Comprueba tu conexión o si el servidor ya tiene esta función disponible.'**
  String get deleteAccountError;

  /// No description provided for @faqs.
  ///
  /// In es, this message translates to:
  /// **'Preguntas frecuentes'**
  String get faqs;

  /// No description provided for @faqWhatIsAppQ.
  ///
  /// In es, this message translates to:
  /// **'¿Qué es DueGlow?'**
  String get faqWhatIsAppQ;

  /// No description provided for @faqWhatIsAppA.
  ///
  /// In es, this message translates to:
  /// **'DueGlow es una app para organizar productos de belleza, controlar fechas de caducidad y crear rutinas de cuidado personal. Te ayuda a mantener hábitos de autocuidado de forma simple y visual.'**
  String get faqWhatIsAppA;

  /// No description provided for @faqAddProductQ.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo añado un producto?'**
  String get faqAddProductQ;

  /// No description provided for @faqAddProductA.
  ///
  /// In es, this message translates to:
  /// **'Desde la pestaña «Nuevo» puedes escanear el código de barras, buscar en la base de datos o rellenar los datos manualmente. También puedes añadir productos desde los resultados de búsqueda o al escanear uno que no exista en la base de datos.'**
  String get faqAddProductA;

  /// No description provided for @faqExpirationQ.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo funcionan la caducidad y el PAO?'**
  String get faqExpirationQ;

  /// No description provided for @faqExpirationA.
  ///
  /// In es, this message translates to:
  /// **'Puedes indicar la fecha de caducidad impresa en el envase o el PAO (periodo tras abrir, p. ej. «6M»). Si marcas un producto como abierto con una fecha, la app puede calcular cuándo caduca según el PAO. En inicio verás los que caducan pronto.'**
  String get faqExpirationA;

  /// No description provided for @faqProductListsQ.
  ///
  /// In es, this message translates to:
  /// **'¿Qué son las listas de productos?'**
  String get faqProductListsQ;

  /// No description provided for @faqProductListsA.
  ///
  /// In es, this message translates to:
  /// **'En «Mis productos» tienes varias listas: los que tienes, los deseados (wishlist) y los que has terminado este mes. Puedes cambiar de lista desde el detalle de cada producto.'**
  String get faqProductListsA;

  /// No description provided for @faqRoutinesQ.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo creo una rutina de skincare?'**
  String get faqRoutinesQ;

  /// No description provided for @faqRoutinesA.
  ///
  /// In es, this message translates to:
  /// **'Ve a «Rutinas», crea una rutina de mañana o de noche, elige los días de la semana y añade productos de tu tocador. En inicio aparecerá tu próxima rutina según el calendario.'**
  String get faqRoutinesA;

  /// No description provided for @faqScanNotFoundQ.
  ///
  /// In es, this message translates to:
  /// **'El escáner no encuentra mi producto, ¿qué hago?'**
  String get faqScanNotFoundQ;

  /// No description provided for @faqScanNotFoundA.
  ///
  /// In es, this message translates to:
  /// **'Si el código de barras no está en la base de datos, la app te ofrecerá crear el producto manualmente. Rellena nombre, marca y, si puedes, caducidad o PAO para llevar un control correcto.'**
  String get faqScanNotFoundA;

  /// No description provided for @faqExpiringSoonQ.
  ///
  /// In es, this message translates to:
  /// **'¿Dónde veo los productos que caducan pronto?'**
  String get faqExpiringSoonQ;

  /// No description provided for @faqExpiringSoonA.
  ///
  /// In es, this message translates to:
  /// **'En la pantalla de inicio hay una sección «Próximos a caducar» con los productos que debes usar antes. Priorízalos para no desperdiciarlos.'**
  String get faqExpiringSoonA;

  /// No description provided for @faqSettingsLangQ.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo cambio el idioma o el tema?'**
  String get faqSettingsLangQ;

  /// No description provided for @faqSettingsLangA.
  ///
  /// In es, this message translates to:
  /// **'Abre «Configuración» desde el menú (icono de tres líneas). Ahí puedes activar notificaciones, elegir modo claro u oscuro y cambiar entre español, inglés y ruso.'**
  String get faqSettingsLangA;

  /// No description provided for @faqOpenFinishQ.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo marco un producto como abierto o terminado?'**
  String get faqOpenFinishQ;

  /// No description provided for @faqOpenFinishA.
  ///
  /// In es, this message translates to:
  /// **'En el detalle del producto puedes marcarlo como abierto (con la fecha del día u otra), cerrarlo de nuevo o marcarlo como terminado. Los terminados se registran en tu historial de uso mensual.'**
  String get faqOpenFinishA;

  /// No description provided for @faqDeleteAccountQ.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo borro mi cuenta?'**
  String get faqDeleteAccountQ;

  /// No description provided for @faqDeleteAccountA.
  ///
  /// In es, this message translates to:
  /// **'En «Configuración», al final, está «Borrar cuenta». Es una acción permanente: se eliminan productos, rutinas, imágenes y todos los datos asociados. Solo confírmalo si estás seguro.'**
  String get faqDeleteAccountA;
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
      <String>['en', 'es', 'ru'].contains(locale.languageCode);

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
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
