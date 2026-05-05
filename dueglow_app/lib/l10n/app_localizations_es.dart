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
  String get pass8Char => 'Mínimo 8 caracteres';

  @override
  String get strongPasswordHint =>
      'Debe incluir mayúscula, minúscula, número y símbolo';

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
  String get expiredLabel => 'Caducado';

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
  String get editProfile => 'Editar perfil';

  @override
  String get phone => 'Teléfono';

  @override
  String get phoneHint => '+34 123 456 789';

  @override
  String get birthDate => 'Fecha de nacimiento';

  @override
  String get birthDateHint => 'DD/MM/AAAA';

  @override
  String get changePasswordOptional => 'Cambiar contraseña (opcional)';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get selectBirthDate => 'Selecciona tu fecha de nacimiento';

  @override
  String get selectProfilePhotoTitle => 'Seleccionar foto de perfil';

  @override
  String get deletePhoto => 'Eliminar foto';

  @override
  String get photoMarkedForDeletion => 'Foto marcada para eliminar al guardar';

  @override
  String get deletePhotoError => 'Error al eliminar la foto';

  @override
  String get uploadPhotoError => 'Error al subir la nueva foto';

  @override
  String get profileUpdatedSuccess => 'Perfil actualizado correctamente';

  @override
  String get profileUpdateError => 'Error al actualizar el perfil';

  @override
  String get nextRoutineTitle => 'Próxima rutina';

  @override
  String get routinesTitle => 'Rutinas';

  @override
  String get createFirstRoutineHomeHint =>
      'Crea tu primera rutina para verla aquí.';

  @override
  String routineProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# productos',
      one: '# producto',
    );
    return '$_temp0';
  }

  @override
  String get slotTodayMorning => 'Hoy mañana';

  @override
  String get slotTodayNight => 'Hoy noche';

  @override
  String get slotTomorrowMorning => 'Mañana mañana';

  @override
  String get slotTomorrowNight => 'Mañana noche';

  @override
  String slotInDaysMorning(int days) {
    return 'En $days días (mañana)';
  }

  @override
  String slotInDaysNight(int days) {
    return 'En $days días (noche)';
  }

  @override
  String get monthlyUsageTitle => 'Uso mensual';

  @override
  String get monthlyUsageDescription =>
      'Productos terminados en los ultimos meses.';

  @override
  String get thisMonthLabel => 'Este mes';

  @override
  String get twelveMonthsLabel => '12 meses';

  @override
  String get noUsageHistory => 'Aun no hay historial de productos usados.';

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

  @override
  String get retry => 'Reintentar';

  @override
  String get clear => 'Limpiar';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterOpened => 'Abiertos';

  @override
  String get filterExpired => 'Caducados';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get russian => 'Ruso';

  @override
  String versionLabel(String version) {
    return 'Versión $version';
  }

  @override
  String get notificationsEnabled => 'Notificaciones activadas';

  @override
  String get notificationsDisabled => 'Notificaciones desactivadas';

  @override
  String get allProducts => 'Todos los productos';

  @override
  String get noProductsRegistered => 'No tienes productos registrados';

  @override
  String get noProductsInHave => 'No tienes productos en \"Tengo\"';

  @override
  String get noProductsInWishlist => 'No tienes productos en \"Deseados\"';

  @override
  String get noFinishedProducts => 'No has registrado productos terminados';

  @override
  String get addFirstProductsHint =>
      'Agrega tus primeros productos escaneando códigos de barras o buscando en la base de datos';

  @override
  String get haveProductsHint =>
      'Los productos que marques como \"Tengo\" aparecerán aquí';

  @override
  String get wishlistProductsHint =>
      'Agrega productos a tu wishlist desde la pantalla de detalles';

  @override
  String get usedProductsHint =>
      'Los productos que has acabado este mes aparecen en esta lista';

  @override
  String get usedProductsInfo =>
      'Estos son los productos que has terminado este mes. Cuando termine el mes, estos productos se eliminarán automáticamente y se almacenarán los datos para el proyecto PAN.';

  @override
  String productsCount(int count, String pluralSuffix) {
    return '$count producto$pluralSuffix';
  }

  @override
  String get searchLoading => 'Buscando...';

  @override
  String get searchErrorTitle => 'Error al buscar';

  @override
  String get searchConnectionError => 'Error al buscar. Revisa tu conexión.';

  @override
  String get searchNoResults => 'No se encontraron productos';

  @override
  String get searchTryAnotherTerm => 'Prueba con otro término de búsqueda';

  @override
  String get searchBeautyProducts => 'Busca productos de belleza';

  @override
  String get searchExamplesExtended =>
      'Ej: \"L\'Oréal\", \"hidratante\", \"champú\"';

  @override
  String get noBrand => 'Sin marca';

  @override
  String get scanProductNotFound => 'Producto no encontrado';

  @override
  String scanNoBarcodeInfo(String barcode) {
    return 'No se encontró información para el código de barras:\n$barcode\n\n¿Quieres crear un nuevo producto manualmente?';
  }

  @override
  String get createProduct => 'Crear producto';

  @override
  String get newProductDefaultName => 'Nuevo producto';

  @override
  String get deleteRoutineTitle => 'Eliminar rutina';

  @override
  String deleteRoutineQuestion(String name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get routineDeleted => 'Rutina eliminada';

  @override
  String get routinesLoadError => 'Error al cargar rutinas';

  @override
  String get routineDeleteError => 'Error al eliminar rutina';

  @override
  String get morning => 'Mañana';

  @override
  String get night => 'Noche';

  @override
  String get newRoutine => 'Nueva rutina';

  @override
  String get noMorningRoutines => 'Sin rutinas de mañana';

  @override
  String get noNightRoutines => 'Sin rutinas de noche';

  @override
  String createFirstRoutineHint(String period) {
    return 'Crea tu primera rutina de $period\ny organiza tus productos de skincare';
  }

  @override
  String get createRoutine => 'Crear rutina';

  @override
  String get selectAtLeastOneDay => 'Selecciona al menos 1 día';

  @override
  String get routineCreatedSuccess => '✓ Rutina creada correctamente';

  @override
  String get routineCreateError => 'Error al crear la rutina';

  @override
  String get routineNameRequiredLabel => 'Nombre de la rutina *';

  @override
  String get routineNameHint => 'Ej: Rutina de mañana';

  @override
  String get requiredField => 'Obligatorio';

  @override
  String get routineType => 'Tipo de rutina';

  @override
  String get weekDays => 'Días de la semana';

  @override
  String get none => 'Ninguno';

  @override
  String get all => 'Todos';

  @override
  String get addProduct => 'Añadir producto';

  @override
  String get noMoreProductsToAdd => 'No hay más productos\npara añadir';

  @override
  String get routineNameLabel => 'Nombre';

  @override
  String get morningRoutineLabel => 'Rutina de mañana';

  @override
  String get nightRoutineLabel => 'Rutina de noche';

  @override
  String get products => 'Productos';

  @override
  String get noProductAdded => 'Ningún producto añadido';

  @override
  String get longPressReorder => 'Mantén pulsado para reordenar';

  @override
  String get noProductsYet => 'Sin productos aún';

  @override
  String get addProductsToBuildRoutine =>
      'Añade productos de tu armario\npara construir tu rutina';

  @override
  String get routineUpdated => 'Rutina actualizada';

  @override
  String get updateError => 'Error al actualizar';

  @override
  String get productRemovedFromRoutine => 'Producto eliminado de la rutina';

  @override
  String get productRemoveError => 'Error al eliminar producto';

  @override
  String get reorderProductsError => 'Error al reordenar productos';

  @override
  String get productAddedToRoutine => 'Producto añadido a la rutina';

  @override
  String get productAddError => 'Error al añadir producto';

  @override
  String get addToRoutine => 'Añadir a rutina';

  @override
  String get productAlreadyInRoutine =>
      'Este producto ya está añadido a esta rutina.';

  @override
  String productAddedToRoutineNamed(String routineName) {
    return 'Producto añadido a la rutina: $routineName';
  }

  @override
  String get home => 'Inicio';

  @override
  String get newTab => 'Nuevo';

  @override
  String get profile => 'Perfil';

  @override
  String get aboutDescription =>
      'DueGlow es una app para organizar productos de belleza, controlar fechas de caducidad y crear rutinas de cuidado personal.\n\nEste proyecto fue creado como Trabajo de Fin de Grado (TFG) del ciclo de Desarrollo de Aplicaciones Multiplataforma (DAM).\n\nObjetivo: ayudar a mantener hábitos de autocuidado de forma simple, práctica y visual.';

  @override
  String get vanity => 'Mi Tocador';

  @override
  String yourProductsOf(String subcategory) {
    return 'Tus productos de $subcategory';
  }

  @override
  String get noCategorizedProductsSection =>
      'Aún no has categorizado ningún producto en esta sección.\nAgrega productos desde la búsqueda o tu lista.';

  @override
  String get featureInDevelopment => 'Funcionalidad en desarrollo';

  @override
  String get defaultUserName => 'Usuario';

  @override
  String morningGreeting(String name) {
    return 'Buenos días, $name';
  }

  @override
  String afternoonGreeting(String name) {
    return 'Buenas tardes, $name';
  }

  @override
  String eveningGreeting(String name) {
    return 'Buenas noches, $name';
  }

  @override
  String get skinGlowTagline => 'Que tu piel nunca deje de brillar';

  @override
  String get prioritizeExpiringHint =>
      'Prioriza estos productos antes de que caduquen';

  @override
  String get errorTitle => 'Error';

  @override
  String get accept => 'Aceptar';

  @override
  String get invalidUserOrPassword => 'Usuario o contraseña incorrectos';

  @override
  String get exitAppTitle => 'Salir de la app';

  @override
  String get exitAppQuestion => '¿Quieres salir de la aplicación?';

  @override
  String get exit => 'Salir';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get comingSoon => 'Función próximamente disponible';

  @override
  String get loginButtonUpper => 'INICIAR SESIÓN';

  @override
  String get dontHaveAccount => '¿No tienes cuenta?';

  @override
  String get createOne => 'Crear una';

  @override
  String get orContinueWith => 'O continuar con';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get enterName => 'Ingrese su nombre';

  @override
  String get min3Chars => 'Mínimo 3 caracteres';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get confirmYourPassword => 'Confirme su contraseña';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get mustAcceptTerms => 'Debes aceptar los términos y condiciones';

  @override
  String get accountCreatedSuccess => '¡Cuenta creada exitosamente!';

  @override
  String get createAccountErrorMaybeEmail =>
      'Error al crear la cuenta. El correo podría estar registrado.';

  @override
  String get startManagingProducts => 'Empieza a gestionar tus productos';

  @override
  String get acceptTermsPrefix => 'Acepto los ';

  @override
  String get termsAndConditions => 'términos y condiciones';

  @override
  String get andThe => ' y la ';

  @override
  String get privacyPolicy => 'política de privacidad';

  @override
  String get createAccountUpper => 'CREAR CUENTA';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get signIn => 'Inicia sesión';

  @override
  String get addProductTitle => 'Añadir Producto';

  @override
  String get scanAction => 'Escanear';

  @override
  String get barcodeSubtitle => 'Código de barras';

  @override
  String get searchAction => 'Buscar';

  @override
  String get onlineProductSubtitle => 'Producto online';

  @override
  String get orAddManuallyUpper => 'O AÑADE MANUALMENTE';

  @override
  String get productNameRequiredLabel => 'Nombre del producto *';

  @override
  String get productNameHint => 'Ej: Crema Hidratante';

  @override
  String get brand => 'Marca';

  @override
  String get brandHint => 'Ej: Nivea';

  @override
  String expiresLabel(String date) {
    return 'Caduca: $date';
  }

  @override
  String get expirationDate => 'Fecha de caducidad';

  @override
  String get saveInMyVanity => 'Guardar en mi tocador';

  @override
  String get productImage => 'Imagen del producto';

  @override
  String get tapToAddImage => 'Toca para añadir imagen';

  @override
  String get addProductImageTitle => 'Añadir imagen del producto';

  @override
  String get takePhoto => 'Tomar foto';

  @override
  String get chooseFromGallery => 'Seleccionar de galería';

  @override
  String get deleteImage => 'Eliminar imagen';

  @override
  String get imageDeleted => 'Imagen eliminada';

  @override
  String get imageCapturedSuccess => 'Imagen capturada correctamente';

  @override
  String get imageCaptureError => 'No se pudo capturar la imagen';

  @override
  String get imageSelectedSuccess => 'Imagen seleccionada correctamente';

  @override
  String get imageSelectError => 'No se pudo seleccionar la imagen';

  @override
  String get productSavedImageUploadFailed =>
      'Producto guardado pero la imagen no se pudo subir';

  @override
  String get productAddedSuccess => '✓ Producto añadido correctamente';

  @override
  String get saveProductError => 'Error al guardar el producto';

  @override
  String get paoDuration => 'Duración tras abrir (PAO)';

  @override
  String get periodAfterOpening => 'Periodo después de la apertura';

  @override
  String get findOpenJarIcon => 'Busca el icono del tarro abierto en el envase';

  @override
  String get customPaoHint => 'O escribe uno personalizado (ej: 9M)';

  @override
  String get category => 'Categoría';

  @override
  String get categoryHint => 'Ej: Facial';

  @override
  String get errorPerformingOperation => 'Error al realizar la operación';

  @override
  String get changeToAnotherList => 'Cambiar a otra lista';

  @override
  String productMovedToList(String list) {
    return '✓ Producto movido a \"$list\"';
  }

  @override
  String get addProductQuestionTitle => 'Agregar producto';

  @override
  String addProductQuestion(String name) {
    return '¿Quieres agregar \"$name\" a tu lista de productos?';
  }

  @override
  String productAddedToList(String name) {
    return '✓ \"$name\" agregado a tu lista';
  }

  @override
  String get productUpdatedSuccess => '✓ Producto actualizado correctamente';

  @override
  String get deleteProductTitle => 'Eliminar producto';

  @override
  String deleteProductQuestion(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\" de tu lista?';
  }

  @override
  String productDeletedFromList(String name) {
    return '✓ \"$name\" eliminado de tu lista';
  }

  @override
  String get deleteProductError => 'Error al eliminar el producto';

  @override
  String get markAsFinishedTitle => 'Marcar como terminado';

  @override
  String markAsFinishedQuestion(String name) {
    return '¿Estás seguro de que has terminado \"$name\"?\n\nEl producto se moverá a la lista de terminados y se registrará en tu historial mensual.';
  }

  @override
  String productMarkedFinished(String name) {
    return '✓ \"$name\" marcado como terminado';
  }

  @override
  String get openProduct => 'Abrir producto';

  @override
  String get today => 'Hoy';

  @override
  String get anotherDate => 'Otra fecha...';

  @override
  String get productMarkedOpened => '✓ Producto marcado como abierto';

  @override
  String get productMarkedClosed => '✓ Producto marcado como cerrado';

  @override
  String get expirationCalculated => '✓ Fecha de caducidad calculada';

  @override
  String get editProductTooltip => 'Editar producto';

  @override
  String get deleteProduct => 'Eliminar producto';

  @override
  String get currentList => 'Lista actual';

  @override
  String get changeListTooltip => 'Cambiar lista';

  @override
  String get addedLabel => 'Agregado';

  @override
  String get expirationLabel => 'Caducidad';

  @override
  String get openedOnLabel => 'Abierto el';

  @override
  String get notes => 'Notas';

  @override
  String get noExpirationInfoWarningTitle => 'Sin información de caducidad';

  @override
  String get noExpirationInfoWarningBody =>
      'Edita el producto para añadir su duración después de abierto (ej: \"6M\") o una fecha de caducidad.';

  @override
  String get addToMyProducts => 'Agregar a mis productos';

  @override
  String get closeProduct => 'Cerrar producto';

  @override
  String get calculateExpiration => 'Calcular caducidad';

  @override
  String get finishedProduct => 'Producto acabado';

  @override
  String get editProduct => 'Editar producto';

  @override
  String get list => 'Lista';

  @override
  String get rating => 'Calificación';

  @override
  String get deleteAll => 'Eliminar todas';

  @override
  String get newCategory => 'Nueva categoría';

  @override
  String get uploadingImage => 'Subiendo imagen...';

  @override
  String get changeProductImageTitle => 'Cambiar imagen del producto';

  @override
  String get imageDeletedSuccess => 'Imagen eliminada correctamente';

  @override
  String get deleteImageError => 'Error al eliminar la imagen';

  @override
  String get nameRequiredError => 'El nombre es obligatorio';

  @override
  String get imageUploadError => 'Error al subir la imagen';

  @override
  String get saveChangesError => 'Error al guardar los cambios';

  @override
  String expirationWithDate(String date) {
    return 'Caducidad: $date';
  }

  @override
  String get addExpirationDate => 'Añadir fecha de caducidad';

  @override
  String get additionalNotes => 'Notas adicionales';

  @override
  String get deleteDateTooltip => 'Eliminar fecha';

  @override
  String get save => 'Guardar';
}
