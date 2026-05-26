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
  String get login => 'Login';

  @override
  String get createAcount => 'Create account';

  @override
  String get email => 'Email';

  @override
  String get userEmailExample => 'user@example.com';

  @override
  String get enterEmailAddress => 'Enter your email';

  @override
  String get invalidAddress => 'Invalid email';

  @override
  String get password => 'Password';

  @override
  String get enterPass => 'Enter your password';

  @override
  String get pass6Char => 'At least 6 characters';

  @override
  String get pass8Char => 'At least 8 characters';

  @override
  String get strongPasswordHint =>
      'Must include uppercase, lowercase, number and symbol';

  @override
  String get myProducts => 'My products';

  @override
  String get seeAll => 'VIEW ALL';

  @override
  String get routines => 'Routines';

  @override
  String get categories => 'Categories';

  @override
  String get expiringSoon => 'Expiring Soon';

  @override
  String get expiredLabel => 'Expired';

  @override
  String get days => 'days';

  @override
  String get allFine => 'All is fine!';

  @override
  String get noProdExpiring => 'No products are about to expire';

  @override
  String get searchProducts => 'Search products';

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
  String get editProfile => 'Edit profile';

  @override
  String get phone => 'Phone';

  @override
  String get phoneHint => '+34 123 456 789';

  @override
  String get birthDate => 'Birth date';

  @override
  String get birthDateHint => 'DD/MM/YYYY';

  @override
  String get changePasswordOptional => 'Change password';

  @override
  String get newPassword => 'New password';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get selectBirthDate => 'Select your birth date';

  @override
  String get selectProfilePhotoTitle => 'Select profile photo';

  @override
  String get deletePhoto => 'Delete photo';

  @override
  String get photoMarkedForDeletion => 'Photo marked for deletion on save';

  @override
  String get deletePhotoError => 'Error deleting photo';

  @override
  String get uploadPhotoError => 'Error uploading the new photo';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String get profileUpdateError => 'Error updating profile';

  @override
  String get nextRoutineTitle => 'Next routine';

  @override
  String get routinesTitle => 'Routines';

  @override
  String get createFirstRoutineHomeHint =>
      'Create your first routine to see it here.';

  @override
  String routineProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# products',
      one: '# product',
    );
    return '$_temp0';
  }

  @override
  String get slotTodayMorning => 'Today morning';

  @override
  String get slotTodayNight => 'Today night';

  @override
  String get slotTomorrowMorning => 'Tomorrow morning';

  @override
  String get slotTomorrowNight => 'Tomorrow night';

  @override
  String slotInDaysMorning(int days) {
    return 'In $days days (morning)';
  }

  @override
  String slotInDaysNight(int days) {
    return 'In $days days (night)';
  }

  @override
  String get monthlyUsageTitle => 'Monthly usage';

  @override
  String get monthlyUsageDescription => 'Products finished in recent months.';

  @override
  String get thisMonthLabel => 'This month';

  @override
  String get twelveMonthsLabel => '12 months';

  @override
  String get noUsageHistory => 'There is no finished products history yet.';

  @override
  String get general => 'General';

  @override
  String get notifications => 'Notifications';

  @override
  String get notifText => 'Receive alerts and updates';

  @override
  String get notifMasterSubtitle => 'Turn all DueGlow reminders on or off';

  @override
  String get notifTypesHeader => 'Reminder types';

  @override
  String get notifExpirationTitle => 'Product expiration';

  @override
  String get notifExpirationSubtitle =>
      'Alerts at 30, 25, 20, 15, 10 and 5 days, on expiry day, and when expired';

  @override
  String get notifRoutinesTitle => 'Skincare routines';

  @override
  String get notifRoutinesSubtitle =>
      'Reminds you before your next morning or night routine';

  @override
  String get notifWeeklyTitle => 'Weekly summary';

  @override
  String get notifWeeklySubtitle =>
      'Every Sunday, a recap of products expiring soon';

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

  @override
  String get retry => 'Retry';

  @override
  String get clear => 'Clear';

  @override
  String get filterAll => 'All';

  @override
  String get filterOpened => 'Opened';

  @override
  String get filterExpired => 'Expired';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get russian => 'Russian';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsDisabled => 'Notifications disabled';

  @override
  String get allProducts => 'All products';

  @override
  String get noProductsRegistered => 'You have no saved products';

  @override
  String get noProductsInHave => 'You have no products in \"Have\"';

  @override
  String get noProductsInWishlist => 'You have no products in \"Wishlist\"';

  @override
  String get noFinishedProducts => 'You have no finished products';

  @override
  String get addFirstProductsHint =>
      'Add your first products by scanning barcodes or searching in the database';

  @override
  String get haveProductsHint => 'Products marked as \"Have\" will appear here';

  @override
  String get wishlistProductsHint =>
      'Add products to your wishlist from the detail screen';

  @override
  String get usedProductsHint =>
      'Products you finished this month appear in this list';

  @override
  String get usedProductsInfo =>
      'These are the products you finished this month. When the month ends, these products will be automatically removed and the data will be stored for the PAN project.';

  @override
  String productsCount(int count, String pluralSuffix) {
    return '$count product$pluralSuffix';
  }

  @override
  String get searchLoading => 'Searching...';

  @override
  String get searchErrorTitle => 'Search error';

  @override
  String get searchConnectionError => 'Search failed. Check your connection.';

  @override
  String get searchNoResults => 'No products found';

  @override
  String get searchTryAnotherTerm => 'Try another search term';

  @override
  String get searchBeautyProducts => 'Search beauty products';

  @override
  String get searchExamplesExtended =>
      'Ex: \"L\'Oréal\", \"moisturizer\", \"shampoo\"';

  @override
  String get noBrand => 'No brand';

  @override
  String get scanProductNotFound => 'Product not found';

  @override
  String scanNoBarcodeInfo(String barcode) {
    return 'No information was found for barcode:\n$barcode\n\nDo you want to create a new product manually?';
  }

  @override
  String get createProduct => 'Create product';

  @override
  String get newProductDefaultName => 'New product';

  @override
  String get deleteRoutineTitle => 'Delete routine';

  @override
  String deleteRoutineQuestion(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get routineDeleted => 'Routine deleted';

  @override
  String get routinesLoadError => 'Failed to load routines';

  @override
  String get routineDeleteError => 'Failed to delete routine';

  @override
  String get morning => 'Morning';

  @override
  String get night => 'Night';

  @override
  String get newRoutine => 'New routine';

  @override
  String get noMorningRoutines => 'No morning routines';

  @override
  String get noNightRoutines => 'No night routines';

  @override
  String createFirstRoutineHint(String period) {
    return 'Create your first $period routine\nand organize your skincare products';
  }

  @override
  String get createRoutine => 'Create routine';

  @override
  String get selectAtLeastOneDay => 'Select at least 1 day';

  @override
  String get routineCreatedSuccess => '✓ Routine created successfully';

  @override
  String get routineCreateError => 'Failed to create routine';

  @override
  String get routineNameRequiredLabel => 'Routine name *';

  @override
  String get routineNameHint => 'Ex: Morning routine';

  @override
  String get requiredField => 'Required';

  @override
  String get routineType => 'Routine type';

  @override
  String get weekDays => 'Week days';

  @override
  String get none => 'None';

  @override
  String get all => 'All';

  @override
  String get addProduct => 'Add product';

  @override
  String get noMoreProductsToAdd => 'No more products\nto add';

  @override
  String get routineNameLabel => 'Name';

  @override
  String get morningRoutineLabel => 'Morning routine';

  @override
  String get nightRoutineLabel => 'Night routine';

  @override
  String get products => 'Products';

  @override
  String get noProductAdded => 'No product added';

  @override
  String get longPressReorder => 'Long press to reorder';

  @override
  String get noProductsYet => 'No products yet';

  @override
  String get addProductsToBuildRoutine =>
      'Add products from your stash\nto build your routine';

  @override
  String get routineUpdated => 'Routine updated';

  @override
  String get updateError => 'Update failed';

  @override
  String get productRemovedFromRoutine => 'Product removed from routine';

  @override
  String get productRemoveError => 'Failed to remove product';

  @override
  String get reorderProductsError => 'Failed to reorder products';

  @override
  String get productAddedToRoutine => 'Product added to routine';

  @override
  String get productAddError => 'Failed to add product';

  @override
  String get addToRoutine => 'Add to routine';

  @override
  String get productAlreadyInRoutine =>
      'This product is already added to this routine.';

  @override
  String productAddedToRoutineNamed(String routineName) {
    return 'Product added to routine: $routineName';
  }

  @override
  String get home => 'Home';

  @override
  String get newTab => 'New';

  @override
  String get profile => 'Profile';

  @override
  String get aboutDescription =>
      'DueGlow is an app to organize beauty products, track expiration dates, and build personal care routines.\n\nThis project was created as a Final Degree Project (TFG) for the Multiplatform Application Development program (DAM).\n\nGoal: help users keep self-care habits in a simple, practical, and visual way.';

  @override
  String get vanity => 'My Vanity';

  @override
  String yourProductsOf(String subcategory) {
    return 'Your $subcategory products';
  }

  @override
  String get noCategorizedProductsSection =>
      'You have not categorized any products in this section yet.\nAdd products from your inventory to see them organized by section.';

  @override
  String get featureInDevelopment => 'Feature in development';

  @override
  String get defaultUserName => 'User';

  @override
  String morningGreeting(String name) {
    return 'Good morning, $name';
  }

  @override
  String afternoonGreeting(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String eveningGreeting(String name) {
    return 'Good evening, $name';
  }

  @override
  String get skinGlowTagline => 'Let your skin always shine';

  @override
  String get prioritizeExpiringHint =>
      'Prioritize these products before they expire';

  @override
  String get errorTitle => 'Error';

  @override
  String get accept => 'Accept';

  @override
  String get invalidUserOrPassword => 'Incorrect username or password';

  @override
  String get exitAppTitle => 'Exit app';

  @override
  String get exitAppQuestion => 'Do you want to exit the app?';

  @override
  String get exit => 'Exit';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get comingSoon => 'Feature coming soon';

  @override
  String get loginButtonUpper => 'SIGN IN';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createOne => 'Create one';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get fullName => 'Full name';

  @override
  String get userNameLabel => 'Username';

  @override
  String get enterName => 'Enter your name';

  @override
  String get min3Chars => 'Minimum 3 characters';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get passwordsDontMatch => 'Passwords do not match';

  @override
  String get mustAcceptTerms => 'You must accept the terms and conditions';

  @override
  String get accountCreatedSuccess => 'Account created successfully!';

  @override
  String get createAccountErrorMaybeEmail =>
      'Failed to create account. The email might already be registered.';

  @override
  String get startManagingProducts => 'Start managing your products';

  @override
  String get acceptTermsPrefix => 'I accept the ';

  @override
  String get termsAndConditions => 'terms and conditions';

  @override
  String get andThe => ' and the ';

  @override
  String get privacyPolicy => 'privacy policy';

  @override
  String get createAccountUpper => 'CREATE ACCOUNT';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign in';

  @override
  String get addProductTitle => 'Add Product';

  @override
  String get scanAction => 'Scan';

  @override
  String get barcodeSubtitle => 'Barcode';

  @override
  String get searchAction => 'Search';

  @override
  String get onlineProductSubtitle => 'Online product';

  @override
  String get orAddManuallyUpper => 'OR ADD MANUALLY';

  @override
  String get productNameRequiredLabel => 'Product name *';

  @override
  String get productNameHint => 'Ex: Moisturizing cream';

  @override
  String get brand => 'Brand';

  @override
  String get brandRequiredLabel => 'Brand *';

  @override
  String get brandHint => 'Ex: Nivea';

  @override
  String expiresLabel(String date) {
    return 'Expires: $date';
  }

  @override
  String get expirationDate => 'Expiration date';

  @override
  String get saveInMyVanity => 'Save in my vanity';

  @override
  String get productImage => 'Product image';

  @override
  String get tapToAddImage => 'Tap to add image';

  @override
  String get addProductImageTitle => 'Add product image';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get deleteImage => 'Delete image';

  @override
  String get imageDeleted => 'Image deleted';

  @override
  String get imageCapturedSuccess => 'Image captured successfully';

  @override
  String get imageCaptureError => 'Could not capture image';

  @override
  String get imageSelectedSuccess => 'Image selected successfully';

  @override
  String get imageSelectError => 'Could not select image';

  @override
  String get productSavedImageUploadFailed =>
      'Product saved but image upload failed';

  @override
  String get productAddedSuccess => '✓ Product added successfully';

  @override
  String get saveProductError => 'Failed to save product';

  @override
  String get paoDuration => 'Duration after opening (PAO)';

  @override
  String get periodAfterOpening => 'Period after opening';

  @override
  String get findOpenJarIcon => 'Look for the open-jar icon on the package';

  @override
  String get customPaoHint => 'Or type a custom one (e.g. 9M)';

  @override
  String get category => 'Category';

  @override
  String get categoryHint => 'Ex: Face';

  @override
  String get errorPerformingOperation => 'Error performing operation';

  @override
  String get changeToAnotherList => 'Move to another list';

  @override
  String productMovedToList(String list) {
    return '✓ Product moved to \"$list\"';
  }

  @override
  String get addProductQuestionTitle => 'Add product';

  @override
  String addProductQuestion(String name) {
    return 'Do you want to add \"$name\" to your products list?';
  }

  @override
  String productAddedToList(String name) {
    return '✓ \"$name\" added to your list';
  }

  @override
  String get productUpdatedSuccess => '✓ Product updated successfully';

  @override
  String get deleteProductTitle => 'Delete product';

  @override
  String deleteProductQuestion(String name) {
    return 'Are you sure you want to delete \"$name\" from your list?';
  }

  @override
  String productDeletedFromList(String name) {
    return '✓ \"$name\" removed from your list';
  }

  @override
  String get deleteProductError => 'Error deleting product';

  @override
  String get markAsFinishedTitle => 'Mark as finished';

  @override
  String markAsFinishedQuestion(String name) {
    return 'Are you sure you have finished \"$name\"?\n\nThe product will be moved to the finished list and recorded in your monthly history.';
  }

  @override
  String productMarkedFinished(String name) {
    return '✓ \"$name\" marked as finished';
  }

  @override
  String get openProduct => 'Open product';

  @override
  String get today => 'Today';

  @override
  String get anotherDate => 'Another date...';

  @override
  String get productMarkedOpened => '✓ Product marked as opened';

  @override
  String get productMarkedClosed => '✓ Product marked as closed';

  @override
  String get expirationCalculated => '✓ Expiration date calculated';

  @override
  String get editProductTooltip => 'Edit product';

  @override
  String get deleteProduct => 'Delete product';

  @override
  String get currentList => 'Current list';

  @override
  String get changeListTooltip => 'Change list';

  @override
  String get addedLabel => 'Added';

  @override
  String get expirationLabel => 'Expiration';

  @override
  String get openedOnLabel => 'Opened on';

  @override
  String get notes => 'Notes';

  @override
  String get noExpirationInfoWarningTitle => 'No expiration information';

  @override
  String get noExpirationInfoWarningBody =>
      'Edit the product to add its period after opening (e.g. \"6M\") or an expiration date.';

  @override
  String get addToMyProducts => 'Add to my products';

  @override
  String get closeProduct => 'Close product';

  @override
  String get calculateExpiration => 'Calculate expiration';

  @override
  String get finishedProduct => 'Finished product';

  @override
  String get editProduct => 'Edit product';

  @override
  String get list => 'List';

  @override
  String get rating => 'Rating';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get newCategory => 'New category';

  @override
  String get uploadingImage => 'Uploading image...';

  @override
  String get changeProductImageTitle => 'Change product image';

  @override
  String get imageDeletedSuccess => 'Image deleted successfully';

  @override
  String get deleteImageError => 'Error deleting image';

  @override
  String get nameRequiredError => 'Name is required';

  @override
  String get brandRequiredError => 'Brand is required';

  @override
  String get imageUploadError => 'Error uploading image';

  @override
  String get saveChangesError => 'Error saving changes';

  @override
  String expirationWithDate(String date) {
    return 'Expiration: $date';
  }

  @override
  String get addExpirationDate => 'Add expiration date';

  @override
  String get additionalNotes => 'Additional notes';

  @override
  String get deleteDateTooltip => 'Delete date';

  @override
  String get save => 'Save';

  @override
  String get selectCategoriesTitle => 'Select categories';

  @override
  String get chooseCategories => 'Choose categories';

  @override
  String get saveCategorySelection => 'Save selection';

  @override
  String get sectionFacial => 'Face';

  @override
  String get sectionCorporal => 'Body';

  @override
  String get sectionCapilar => 'Hair';

  @override
  String get sectionMaquillaje => 'Makeup';

  @override
  String get sectionMedicamentosSuplementos => 'Medication and supplements';

  @override
  String get sectionOtros => 'Other';

  @override
  String get subLimpieza => 'Cleanser';

  @override
  String get subSerums => 'Serums';

  @override
  String get subCremas => 'Creams';

  @override
  String get subContornoOjos => 'Eye contour';

  @override
  String get subTratamientos => 'Treatments';

  @override
  String get subProteccion => 'Protection';

  @override
  String get subGel => 'Gel';

  @override
  String get subCrema => 'Cream';

  @override
  String get subManos => 'Hands';

  @override
  String get subDesodorante => 'Deodorant';

  @override
  String get subChampu => 'Shampoo';

  @override
  String get subMascarilla => 'Mask';

  @override
  String get subAcondicionador => 'Conditioner';

  @override
  String get subSerumCapilar => 'Hair serum';

  @override
  String get subRostro => 'Face';

  @override
  String get subOjos => 'Eyes';

  @override
  String get subLabios => 'Lips';

  @override
  String get subCejas => 'Eyebrows';

  @override
  String get subMedicamentos => 'Medication';

  @override
  String get subSuplementos => 'Supplements';

  @override
  String get subUnas => 'Nails';

  @override
  String get subFragancia => 'Fragrance';

  @override
  String get subCacaoLabial => 'Lip balm';

  @override
  String get subHigieneIntima => 'Intimate hygiene';

  @override
  String get subSolaresCorporales => 'Body sun care';

  @override
  String get subOtros => 'Other';

  @override
  String get deleteAccountSectionTitle => 'Account';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSubtitle => 'Permanent and irreversible';

  @override
  String get deleteAccountDialogTitle => 'Delete your account?';

  @override
  String get deleteAccountDialogMessage =>
      'This cannot be undone. You will permanently lose everything: products, routines, images, and all data tied to your account.\n\nOnly confirm if you are sure.';

  @override
  String get deleteAccountConfirmButton => 'Yes, delete my account';

  @override
  String get deleteAccountDeleting => 'Deleting account…';

  @override
  String get deleteAccountSuccess =>
      'Account removed. You have been signed out.';

  @override
  String get deleteAccountError =>
      'Could not delete the account. Check your connection or whether the server supports this yet.';

  @override
  String get faqs => 'Frequently asked questions';

  @override
  String get faqWhatIsAppQ => 'What is DueGlow?';

  @override
  String get faqWhatIsAppA =>
      'DueGlow is an app to organize beauty products, track expiration dates, and build personal care routines. It helps you keep self-care habits simple and visual.';

  @override
  String get faqAddProductQ => 'How do I add a product?';

  @override
  String get faqAddProductA =>
      'From the \"New\" tab you can scan a barcode, search the database, or enter details manually. You can also add products from search results or when a scan is not found in the database.';

  @override
  String get faqExpirationQ => 'How do expiration and PAO work?';

  @override
  String get faqExpirationA =>
      'You can set the printed expiration date or PAO (period after opening, e.g. \"6M\"). If you mark a product as opened with a date, the app can calculate when it expires from the PAO. Home shows items expiring soon.';

  @override
  String get faqProductListsQ => 'What are the product lists?';

  @override
  String get faqProductListsA =>
      'In \"My products\" you have several lists: items you have, wishlist, and products you finished this month. You can change the list from each product\'s detail screen.';

  @override
  String get faqRoutinesQ => 'How do I create a skincare routine?';

  @override
  String get faqRoutinesA =>
      'Go to \"Routines\", create a morning or night routine, pick the days of the week, and add products from your vanity. Home shows your next routine based on the schedule.';

  @override
  String get faqScanNotFoundQ =>
      'The scanner can\'t find my product — what now?';

  @override
  String get faqScanNotFoundA =>
      'If the barcode is not in the database, the app lets you create the product manually. Fill in name, brand, and expiration or PAO when possible for accurate tracking.';

  @override
  String get faqExpiringSoonQ => 'Where do I see products expiring soon?';

  @override
  String get faqExpiringSoonA =>
      'On the home screen, the \"Expiring Soon\" section lists products to use before they go bad. Prioritize them to avoid waste.';

  @override
  String get faqSettingsLangQ => 'How do I change language or theme?';

  @override
  String get faqSettingsLangA =>
      'Open \"Settings\" from the menu (three-line icon). There you can toggle notifications, choose light or dark mode, and switch between Spanish, English, and Russian.';

  @override
  String get faqOpenFinishQ => 'How do I mark a product as opened or finished?';

  @override
  String get faqOpenFinishA =>
      'On the product detail screen you can mark it as opened (today or another date), close it again, or mark it as finished. Finished items are recorded in your monthly usage history.';

  @override
  String get faqDeleteAccountQ => 'How do I delete my account?';

  @override
  String get faqDeleteAccountA =>
      'In \"Settings\", at the bottom, tap \"Delete account\". This is permanent: products, routines, images, and all linked data are removed. Only confirm if you are sure.';

  @override
  String get tutorialSkip => 'Skip';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialBack => 'Back';

  @override
  String get tutorialFinish => 'Get started!';

  @override
  String tutorialStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get tutorialReplayTitle => 'View app tutorial';

  @override
  String get tutorialReplaySubtitle =>
      'Walk through each section again: home, products, routines, and more.';

  @override
  String get tutorialWelcomeTitle => 'Welcome to DueGlow';

  @override
  String get tutorialWelcomeBody =>
      'We\'ll guide you through the main sections so you know where everything is and how to move around the app.';

  @override
  String get tutorialHomeTitle => 'Home';

  @override
  String get tutorialHomeBody =>
      'See your next routine, products expiring soon, and your monthly usage summary. This is your daily dashboard.';

  @override
  String get tutorialProductsTitle => 'My products';

  @override
  String get tutorialProductsBody =>
      'Manage what you own, your wishlist, and what you\'ve finished. Filter by opened or expired and tap a product for details.';

  @override
  String get tutorialNewTitle => 'Add product';

  @override
  String get tutorialNewBody =>
      'Create products by scanning a barcode, searching the database, or filling in the details manually.';

  @override
  String get tutorialRoutinesTitle => 'Routines';

  @override
  String get tutorialRoutinesBody =>
      'Create morning or night routines, pick weekdays, and add products from your vanity.';

  @override
  String get tutorialVanityTitle => 'Vanity by category';

  @override
  String get tutorialVanityBody =>
      'Browse your products organized by beauty category: skincare, makeup, hair, and more.';

  @override
  String get tutorialDrawerTitle => 'Side menu';

  @override
  String get tutorialDrawerBody =>
      'Tap the menu icon (☰) at the top right for settings, edit profile, FAQs, and log out.';

  @override
  String get tutorialDoneTitle => 'You\'re all set!';

  @override
  String get tutorialDoneBody =>
      'You know the essentials. You can replay this tutorial anytime from the top of the FAQs screen.';
}
