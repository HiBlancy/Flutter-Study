// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'DueGlow';

  @override
  String helloUser(String name) {
    return 'Привет, $name!';
  }

  @override
  String get login => 'Войти';

  @override
  String get createAcount => 'Создать аккаунт';

  @override
  String get email => 'Эл. почта';

  @override
  String get userEmailExample => 'user@example.com';

  @override
  String get enterEmailAddress => 'Введите вашу почту';

  @override
  String get invalidAddress => 'Неверный адрес почты';

  @override
  String get password => 'Пароль';

  @override
  String get enterPass => 'Введите пароль';

  @override
  String get pass6Char => 'Минимум 6 символов';

  @override
  String get pass8Char => 'Минимум 8 символов';

  @override
  String get strongPasswordHint =>
      'Должен содержать заглавную, строчную букву, цифру и символ';

  @override
  String get myProducts => 'Мои продукты';

  @override
  String get seeAll => 'ПОКАЗАТЬ ВСЕ';

  @override
  String get routines => 'Рутины';

  @override
  String get categories => 'Категории';

  @override
  String get expiringSoon => 'Скоро истекает срок';

  @override
  String get expiredLabel => 'Просрочено';

  @override
  String get days => 'дней';

  @override
  String get allFine => 'Все в порядке!';

  @override
  String get noProdExpiring => 'Нет продуктов с истекающим сроком';

  @override
  String get searchProducts => 'Поиск продуктов';

  @override
  String get searchNameBrand => 'Поиск по названию или бренду...';

  @override
  String get exmapleSearch => 'Пример: \"Yves Rocher\", \"увлажняющий\"';

  @override
  String get camera => 'Камера';

  @override
  String get aimBarcode => 'Наведите на штрихкод';

  @override
  String get settings => 'Настройки';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get phone => 'Телефон';

  @override
  String get phoneHint => '+34 123 456 789';

  @override
  String get birthDate => 'Дата рождения';

  @override
  String get birthDateHint => 'ДД/ММ/ГГГГ';

  @override
  String get changePasswordOptional => 'Изменить пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get selectBirthDate => 'Выберите дату рождения';

  @override
  String get selectProfilePhotoTitle => 'Выбрать фото профиля';

  @override
  String get deletePhoto => 'Удалить фото';

  @override
  String get photoMarkedForDeletion =>
      'Фото отмечено для удаления при сохранении';

  @override
  String get deletePhotoError => 'Ошибка при удалении фото';

  @override
  String get uploadPhotoError => 'Ошибка при загрузке нового фото';

  @override
  String get profileUpdatedSuccess => 'Профиль успешно обновлен';

  @override
  String get profileUpdateError => 'Ошибка при обновлении профиля';

  @override
  String get nextRoutineTitle => 'Следующая рутина';

  @override
  String get routinesTitle => 'Рутины';

  @override
  String get createFirstRoutineHomeHint =>
      'Создайте первую рутину, чтобы увидеть ее здесь.';

  @override
  String routineProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# продукта',
      many: '# продуктов',
      few: '# продукта',
      one: '# продукт',
    );
    return '$_temp0';
  }

  @override
  String get slotTodayMorning => 'Сегодня утром';

  @override
  String get slotTodayNight => 'Сегодня вечером';

  @override
  String get slotTomorrowMorning => 'Завтра утром';

  @override
  String get slotTomorrowNight => 'Завтра вечером';

  @override
  String slotInDaysMorning(int days) {
    return 'Через $days дней (утром)';
  }

  @override
  String slotInDaysNight(int days) {
    return 'Через $days дней (вечером)';
  }

  @override
  String get monthlyUsageTitle => 'Ежемесячное использование';

  @override
  String get monthlyUsageDescription =>
      'Продукты, завершенные за последние месяцы.';

  @override
  String get thisMonthLabel => 'Этот месяц';

  @override
  String get twelveMonthsLabel => '12 месяцев';

  @override
  String get noUsageHistory => 'Пока нет истории завершенных продуктов.';

  @override
  String get general => 'Общие';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notifText => 'Получать уведомления и обновления';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get lightMode => 'Светлая тема';

  @override
  String get darkMode => 'Темная тема';

  @override
  String get language => 'Язык';

  @override
  String get information => 'Информация';

  @override
  String get about => 'О приложении';

  @override
  String get logout => 'Выйти';

  @override
  String get retry => 'Повторить';

  @override
  String get clear => 'Очистить';

  @override
  String get filterAll => 'Все';

  @override
  String get filterOpened => 'Открытые';

  @override
  String get filterExpired => 'Просроченные';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get english => 'Английский';

  @override
  String get spanish => 'Испанский';

  @override
  String get russian => 'Русский';

  @override
  String versionLabel(String version) {
    return 'Версия $version';
  }

  @override
  String get notificationsEnabled => 'Уведомления включены';

  @override
  String get notificationsDisabled => 'Уведомления выключены';

  @override
  String get allProducts => 'Все продукты';

  @override
  String get noProductsRegistered => 'У вас нет сохраненных продуктов';

  @override
  String get noProductsInHave => 'У вас нет продуктов в списке \"Есть\"';

  @override
  String get noProductsInWishlist =>
      'У вас нет продуктов в списке \"Желаемое\"';

  @override
  String get noFinishedProducts => 'У вас нет завершенных продуктов';

  @override
  String get addFirstProductsHint =>
      'Добавьте первые продукты, сканируя штрихкоды или выполняя поиск в базе данных';

  @override
  String get haveProductsHint =>
      'Продукты, отмеченные как \"Есть\", появятся здесь';

  @override
  String get wishlistProductsHint =>
      'Добавляйте продукты в желаемое с экрана деталей';

  @override
  String get usedProductsHint =>
      'Продукты, которые вы закончили в этом месяце, отображаются здесь';

  @override
  String get usedProductsInfo =>
      'Это продукты, которые вы закончили в этом месяце. В конце месяца они будут автоматически удалены, а данные сохранятся для проекта PAN.';

  @override
  String productsCount(int count, String pluralSuffix) {
    return '$count продукт$pluralSuffix';
  }

  @override
  String get searchLoading => 'Поиск...';

  @override
  String get searchErrorTitle => 'Ошибка поиска';

  @override
  String get searchConnectionError =>
      'Не удалось выполнить поиск. Проверьте соединение.';

  @override
  String get searchNoResults => 'Продукты не найдены';

  @override
  String get searchTryAnotherTerm => 'Попробуйте другой запрос';

  @override
  String get searchBeautyProducts => 'Ищите косметические продукты';

  @override
  String get searchExamplesExtended =>
      'Пример: \"L\'Oréal\", \"увлажняющий\", \"шампунь\"';

  @override
  String get noBrand => 'Без бренда';

  @override
  String get scanProductNotFound => 'Продукт не найден';

  @override
  String scanNoBarcodeInfo(String barcode) {
    return 'Информация по штрихкоду не найдена:\n$barcode\n\nХотите создать новый продукт вручную?';
  }

  @override
  String get createProduct => 'Создать продукт';

  @override
  String get newProductDefaultName => 'Новый продукт';

  @override
  String get deleteRoutineTitle => 'Удалить рутину';

  @override
  String deleteRoutineQuestion(String name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String get routineDeleted => 'Рутина удалена';

  @override
  String get routinesLoadError => 'Не удалось загрузить рутины';

  @override
  String get routineDeleteError => 'Не удалось удалить рутину';

  @override
  String get morning => 'Утро';

  @override
  String get night => 'Вечер';

  @override
  String get newRoutine => 'Новая рутина';

  @override
  String get noMorningRoutines => 'Нет утренних рутин';

  @override
  String get noNightRoutines => 'Нет вечерних рутин';

  @override
  String createFirstRoutineHint(String period) {
    return 'Создайте первую рутину на $period\nи организуйте свои skincare-продукты';
  }

  @override
  String get createRoutine => 'Создать рутину';

  @override
  String get selectAtLeastOneDay => 'Выберите хотя бы 1 день';

  @override
  String get routineCreatedSuccess => '✓ Рутина успешно создана';

  @override
  String get routineCreateError => 'Не удалось создать рутину';

  @override
  String get routineNameRequiredLabel => 'Название рутины *';

  @override
  String get routineNameHint => 'Пример: Утренняя рутина';

  @override
  String get requiredField => 'Обязательное поле';

  @override
  String get routineType => 'Тип рутины';

  @override
  String get weekDays => 'Дни недели';

  @override
  String get none => 'Ничего';

  @override
  String get all => 'Все';

  @override
  String get addProduct => 'Добавить продукт';

  @override
  String get noMoreProductsToAdd => 'Больше нет продуктов\nдля добавления';

  @override
  String get routineNameLabel => 'Название';

  @override
  String get morningRoutineLabel => 'Утренняя рутина';

  @override
  String get nightRoutineLabel => 'Вечерняя рутина';

  @override
  String get products => 'Продукты';

  @override
  String get noProductAdded => 'Продукты не добавлены';

  @override
  String get longPressReorder => 'Удерживайте для перестановки';

  @override
  String get noProductsYet => 'Пока нет продуктов';

  @override
  String get addProductsToBuildRoutine =>
      'Добавьте продукты из своего запаса,\nчтобы собрать рутину';

  @override
  String get routineUpdated => 'Рутина обновлена';

  @override
  String get updateError => 'Не удалось обновить';

  @override
  String get productRemovedFromRoutine => 'Продукт удален из рутины';

  @override
  String get productRemoveError => 'Не удалось удалить продукт';

  @override
  String get reorderProductsError => 'Не удалось изменить порядок продуктов';

  @override
  String get productAddedToRoutine => 'Продукт добавлен в рутину';

  @override
  String get productAddError => 'Не удалось добавить продукт';

  @override
  String get addToRoutine => 'Добавить в рутину';

  @override
  String get productAlreadyInRoutine =>
      'Этот продукт уже добавлен в эту рутину.';

  @override
  String productAddedToRoutineNamed(String routineName) {
    return 'Продукт добавлен в рутину: $routineName';
  }

  @override
  String get home => 'Главная';

  @override
  String get newTab => 'Новый';

  @override
  String get profile => 'Профиль';

  @override
  String get aboutDescription =>
      'DueGlow — это приложение для организации косметических продуктов, отслеживания сроков годности и создания персональных рутин ухода.\n\nПроект создан как выпускная работа (TFG) в рамках программы разработки мультиплатформенных приложений (DAM).\n\nЦель: помочь поддерживать привычки ухода за собой простым, удобным и наглядным способом.';

  @override
  String get vanity => 'Мой шкафчик';

  @override
  String yourProductsOf(String subcategory) {
    return 'Ваши продукты категории $subcategory';
  }

  @override
  String get noCategorizedProductsSection =>
      'Вы еще не распределили продукты в этом разделе.\nДобавьте продукты из своего инвентаря, чтобы видеть их по разделам.';

  @override
  String get featureInDevelopment => 'Функция в разработке';

  @override
  String get defaultUserName => 'Пользователь';

  @override
  String morningGreeting(String name) {
    return 'Доброе утро, $name';
  }

  @override
  String afternoonGreeting(String name) {
    return 'Добрый день, $name';
  }

  @override
  String eveningGreeting(String name) {
    return 'Добрый вечер, $name';
  }

  @override
  String get skinGlowTagline => 'Пусть ваша кожа всегда сияет';

  @override
  String get prioritizeExpiringHint =>
      'Сначала используйте продукты с ближайшим сроком';

  @override
  String get errorTitle => 'Ошибка';

  @override
  String get accept => 'Принять';

  @override
  String get invalidUserOrPassword => 'Неверный логин или пароль';

  @override
  String get exitAppTitle => 'Выйти из приложения';

  @override
  String get exitAppQuestion => 'Вы хотите выйти из приложения?';

  @override
  String get exit => 'Выход';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get comingSoon => 'Скоро будет доступно';

  @override
  String get loginButtonUpper => 'ВОЙТИ';

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get createOne => 'Создать';

  @override
  String get orContinueWith => 'Или продолжить через';

  @override
  String get fullName => 'Полное имя';

  @override
  String get userNameLabel => 'Имя пользователя';

  @override
  String get enterName => 'Введите имя';

  @override
  String get min3Chars => 'Минимум 3 символа';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get confirmYourPassword => 'Подтвердите ваш пароль';

  @override
  String get passwordsDontMatch => 'Пароли не совпадают';

  @override
  String get mustAcceptTerms => 'Необходимо принять условия и политику';

  @override
  String get accountCreatedSuccess => 'Аккаунт успешно создан!';

  @override
  String get createAccountErrorMaybeEmail =>
      'Не удалось создать аккаунт. Возможно, почта уже зарегистрирована.';

  @override
  String get startManagingProducts => 'Начните управлять своими продуктами';

  @override
  String get acceptTermsPrefix => 'Я принимаю ';

  @override
  String get termsAndConditions => 'условия использования';

  @override
  String get andThe => ' и ';

  @override
  String get privacyPolicy => 'политику конфиденциальности';

  @override
  String get createAccountUpper => 'СОЗДАТЬ АККАУНТ';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get signIn => 'Войти';

  @override
  String get addProductTitle => 'Добавить продукт';

  @override
  String get scanAction => 'Сканировать';

  @override
  String get barcodeSubtitle => 'Штрихкод';

  @override
  String get searchAction => 'Поиск';

  @override
  String get onlineProductSubtitle => 'Онлайн-продукт';

  @override
  String get orAddManuallyUpper => 'ИЛИ ДОБАВИТЬ ВРУЧНУЮ';

  @override
  String get productNameRequiredLabel => 'Название продукта *';

  @override
  String get productNameHint => 'Пример: Увлажняющий крем';

  @override
  String get brand => 'Бренд';

  @override
  String get brandRequiredLabel => 'Бренд *';

  @override
  String get brandHint => 'Пример: Nivea';

  @override
  String expiresLabel(String date) {
    return 'Годен до: $date';
  }

  @override
  String get expirationDate => 'Срок годности';

  @override
  String get saveInMyVanity => 'Сохранить в мой шкафчик';

  @override
  String get productImage => 'Изображение продукта';

  @override
  String get tapToAddImage => 'Нажмите, чтобы добавить изображение';

  @override
  String get addProductImageTitle => 'Добавить изображение продукта';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get chooseFromGallery => 'Выбрать из галереи';

  @override
  String get deleteImage => 'Удалить изображение';

  @override
  String get imageDeleted => 'Изображение удалено';

  @override
  String get imageCapturedSuccess => 'Изображение успешно снято';

  @override
  String get imageCaptureError => 'Не удалось снять изображение';

  @override
  String get imageSelectedSuccess => 'Изображение успешно выбрано';

  @override
  String get imageSelectError => 'Не удалось выбрать изображение';

  @override
  String get productSavedImageUploadFailed =>
      'Продукт сохранен, но загрузка изображения не удалась';

  @override
  String get productAddedSuccess => '✓ Продукт успешно добавлен';

  @override
  String get saveProductError => 'Не удалось сохранить продукт';

  @override
  String get paoDuration => 'Срок после открытия (PAO)';

  @override
  String get periodAfterOpening => 'Период после открытия';

  @override
  String get findOpenJarIcon => 'Найдите значок открытой баночки на упаковке';

  @override
  String get customPaoHint => 'Или введите свой вариант (например, 9M)';

  @override
  String get category => 'Категория';

  @override
  String get categoryHint => 'Пример: Лицо';

  @override
  String get errorPerformingOperation => 'Ошибка выполнения операции';

  @override
  String get changeToAnotherList => 'Переместить в другой список';

  @override
  String productMovedToList(String list) {
    return '✓ Продукт перемещен в \"$list\"';
  }

  @override
  String get addProductQuestionTitle => 'Добавить продукт';

  @override
  String addProductQuestion(String name) {
    return 'Хотите добавить \"$name\" в список ваших продуктов?';
  }

  @override
  String productAddedToList(String name) {
    return '✓ \"$name\" добавлен в ваш список';
  }

  @override
  String get productUpdatedSuccess => '✓ Продукт успешно обновлен';

  @override
  String get deleteProductTitle => 'Удалить продукт';

  @override
  String deleteProductQuestion(String name) {
    return 'Вы уверены, что хотите удалить \"$name\" из вашего списка?';
  }

  @override
  String productDeletedFromList(String name) {
    return '✓ \"$name\" удален из вашего списка';
  }

  @override
  String get deleteProductError => 'Ошибка при удалении продукта';

  @override
  String get markAsFinishedTitle => 'Отметить как законченный';

  @override
  String markAsFinishedQuestion(String name) {
    return 'Вы уверены, что закончили \"$name\"?\n\nПродукт будет перемещен в список завершенных и записан в месячную историю.';
  }

  @override
  String productMarkedFinished(String name) {
    return '✓ \"$name\" отмечен как законченный';
  }

  @override
  String get openProduct => 'Открыть продукт';

  @override
  String get today => 'Сегодня';

  @override
  String get anotherDate => 'Другая дата...';

  @override
  String get productMarkedOpened => '✓ Продукт отмечен как открытый';

  @override
  String get productMarkedClosed => '✓ Продукт отмечен как закрытый';

  @override
  String get expirationCalculated => '✓ Срок годности рассчитан';

  @override
  String get editProductTooltip => 'Редактировать продукт';

  @override
  String get deleteProduct => 'Удалить продукт';

  @override
  String get currentList => 'Текущий список';

  @override
  String get changeListTooltip => 'Изменить список';

  @override
  String get addedLabel => 'Добавлен';

  @override
  String get expirationLabel => 'Срок годности';

  @override
  String get openedOnLabel => 'Открыт';

  @override
  String get notes => 'Заметки';

  @override
  String get noExpirationInfoWarningTitle => 'Нет информации о сроке годности';

  @override
  String get noExpirationInfoWarningBody =>
      'Отредактируйте продукт, чтобы добавить период после открытия (например, \"6M\") или дату истечения срока.';

  @override
  String get addToMyProducts => 'Добавить в мои продукты';

  @override
  String get closeProduct => 'Закрыть продукт';

  @override
  String get calculateExpiration => 'Рассчитать срок годности';

  @override
  String get finishedProduct => 'Законченный продукт';

  @override
  String get editProduct => 'Редактировать продукт';

  @override
  String get list => 'Список';

  @override
  String get rating => 'Оценка';

  @override
  String get deleteAll => 'Удалить все';

  @override
  String get newCategory => 'Новая категория';

  @override
  String get uploadingImage => 'Загрузка изображения...';

  @override
  String get changeProductImageTitle => 'Изменить изображение продукта';

  @override
  String get imageDeletedSuccess => 'Изображение успешно удалено';

  @override
  String get deleteImageError => 'Ошибка при удалении изображения';

  @override
  String get nameRequiredError => 'Название обязательно';

  @override
  String get brandRequiredError => 'Бренд обязателен';

  @override
  String get imageUploadError => 'Ошибка загрузки изображения';

  @override
  String get saveChangesError => 'Ошибка сохранения изменений';

  @override
  String expirationWithDate(String date) {
    return 'Срок годности: $date';
  }

  @override
  String get addExpirationDate => 'Добавить срок годности';

  @override
  String get additionalNotes => 'Дополнительные заметки';

  @override
  String get deleteDateTooltip => 'Удалить дату';

  @override
  String get save => 'Сохранить';

  @override
  String get selectCategoriesTitle => 'Выберите категории';

  @override
  String get chooseCategories => 'Выбрать категории';

  @override
  String get saveCategorySelection => 'Сохранить выбор';

  @override
  String get sectionFacial => 'Лицо';

  @override
  String get sectionCorporal => 'Тело';

  @override
  String get sectionCapilar => 'Волосы';

  @override
  String get sectionMaquillaje => 'Макияж';

  @override
  String get sectionMedicamentosSuplementos => 'Лекарства и добавки';

  @override
  String get sectionOtros => 'Другое';

  @override
  String get subLimpieza => 'Очищение';

  @override
  String get subSerums => 'Сыворотки';

  @override
  String get subCremas => 'Кремы';

  @override
  String get subContornoOjos => 'Контур глаз';

  @override
  String get subTratamientos => 'Уход';

  @override
  String get subProteccion => 'Защита';

  @override
  String get subGel => 'Гель';

  @override
  String get subCrema => 'Крем';

  @override
  String get subManos => 'Руки';

  @override
  String get subDesodorante => 'Дезодорант';

  @override
  String get subChampu => 'Шампунь';

  @override
  String get subMascarilla => 'Маска';

  @override
  String get subAcondicionador => 'Кондиционер';

  @override
  String get subSerumCapilar => 'Сыворотка для волос';

  @override
  String get subRostro => 'Лицо';

  @override
  String get subOjos => 'Глаза';

  @override
  String get subLabios => 'Губы';

  @override
  String get subCejas => 'Брови';

  @override
  String get subMedicamentos => 'Лекарства';

  @override
  String get subSuplementos => 'Добавки';

  @override
  String get subUnas => 'Ногти';

  @override
  String get subFragancia => 'Ароматы';

  @override
  String get subCacaoLabial => 'Бальзам для губ';

  @override
  String get subHigieneIntima => 'Интимная гигиена';

  @override
  String get subSolaresCorporales => 'Солнцезащита для тела';

  @override
  String get subOtros => 'Другое';

  @override
  String get deleteAccountSectionTitle => 'Аккаунт';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountSubtitle => 'Безвозвратное действие';

  @override
  String get deleteAccountDialogTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountDialogMessage =>
      'Это действие нельзя отменить. Вы навсегда потеряете все данные: продукты, рутины, изображения и всё, что связано с аккаунтом.\n\nПодтверждайте только если вы уверены.';

  @override
  String get deleteAccountConfirmButton => 'Да, удалить мой аккаунт';

  @override
  String get deleteAccountDeleting => 'Удаление аккаунта…';

  @override
  String get deleteAccountSuccess => 'Аккаунт удалён. Вы вышли из системы.';

  @override
  String get deleteAccountError =>
      'Не удалось удалить аккаунт. Проверьте соединение или поддерживает ли сервер эту функцию.';

  @override
  String get faqs => 'Часто задаваемые вопросы';

  @override
  String get faqWhatIsAppQ => 'Что такое DueGlow?';

  @override
  String get faqWhatIsAppA =>
      'DueGlow — приложение для организации косметики, контроля сроков годности и создания рутин ухода. Оно помогает поддерживать привычки заботы о себе просто и наглядно.';

  @override
  String get faqAddProductQ => 'Как добавить продукт?';

  @override
  String get faqAddProductA =>
      'На вкладке «Новый» можно отсканировать штрихкод, найти в базе или ввести данные вручную. Также можно добавить продукт из поиска или при создании после неудачного сканирования.';

  @override
  String get faqExpirationQ => 'Как работают срок годности и PAO?';

  @override
  String get faqExpirationA =>
      'Можно указать дату на упаковке или PAO (срок после вскрытия, напр. «6M»). Если отметить продукт как открытый с датой, приложение рассчитает срок по PAO. На главной видны скоро истекающие товары.';

  @override
  String get faqProductListsQ => 'Что такое списки продуктов?';

  @override
  String get faqProductListsA =>
      'В «Мои продукты» есть списки: что у вас есть, желаемое (wishlist) и завершённые в этом месяце. Список можно сменить на экране деталей продукта.';

  @override
  String get faqRoutinesQ => 'Как создать рутину ухода?';

  @override
  String get faqRoutinesA =>
      'Откройте «Рутины», создайте утреннюю или вечернюю рутину, выберите дни недели и добавьте продукты с туалетного столика. На главной отобразится следующая рутина по расписанию.';

  @override
  String get faqScanNotFoundQ => 'Сканер не находит продукт — что делать?';

  @override
  String get faqScanNotFoundA =>
      'Если штрихкода нет в базе, приложение предложит создать продукт вручную. Укажите название, бренд и по возможности срок или PAO для точного учёта.';

  @override
  String get faqExpiringSoonQ => 'Где смотреть продукты с истекающим сроком?';

  @override
  String get faqExpiringSoonA =>
      'На главном экране в разделе «Скоро истекает срок» перечислены товары, которые стоит использовать в первую очередь.';

  @override
  String get faqSettingsLangQ => 'Как сменить язык или тему?';

  @override
  String get faqSettingsLangA =>
      'Откройте «Настройки» в меню (иконка с тремя линиями). Там можно включить уведомления, выбрать светлую или тёмную тему и переключить испанский, английский или русский.';

  @override
  String get faqOpenFinishQ =>
      'Как отметить продукт открытым или использованным?';

  @override
  String get faqOpenFinishA =>
      'На экране деталей можно отметить открытие (сегодня или другой датой), закрыть снова или отметить как законченный. Завершённые попадают в месячную историю использования.';

  @override
  String get faqDeleteAccountQ => 'Как удалить аккаунт?';

  @override
  String get faqDeleteAccountA =>
      'В «Настройках» внизу — «Удалить аккаунт». Это безвозвратно: удаляются продукты, рутины, изображения и все связанные данные. Подтверждайте только если уверены.';
}
