/// Localized notification copy (kept in sync with l10n ARB strings).
class NotificationMessages {
  static String expirationTitle(String locale, int daysLeft) {
    if (daysLeft <= 0) {
      return _t(locale, es: 'Producto caducado', en: 'Product expired', ru: 'Срок продукта истёк');
    }
    if (daysLeft == 1) {
      return _t(locale, es: 'Caduca mañana', en: 'Expires tomorrow', ru: 'Истекает завтра');
    }
    return _t(
      locale,
      es: 'Caducidad en $daysLeft días',
      en: 'Expires in $daysLeft days',
      ru: 'Истекает через $daysLeft дн.',
    );
  }

  static String expirationBody(String locale, String productName, int daysLeft) {
    if (daysLeft <= 0) {
      return _t(
        locale,
        es: '$productName ha caducado. Revísalo en DueGlow.',
        en: '$productName has expired. Check it in DueGlow.',
        ru: '$productName просрочен. Откройте DueGlow.',
      );
    }
    return _t(
      locale,
      es: 'Usa $productName antes de que caduque.',
      en: 'Use $productName before it expires.',
      ru: 'Используйте $productName до истечения срока.',
    );
  }

  static String routineTitle(String locale) => _t(
        locale,
        es: 'Hora de tu rutina',
        en: 'Routine time',
        ru: 'Время рутины',
      );

  static String routineBody(String locale, String routineName, bool isMorning) {
    final moment = isMorning
        ? _t(locale, es: 'mañana', en: 'morning', ru: 'утро')
        : _t(locale, es: 'noche', en: 'night', ru: 'вечер');
    return _t(
      locale,
      es: 'Es momento de «$routineName» ($moment).',
      en: 'Time for «$routineName» ($moment).',
      ru: 'Пора для «$routineName» ($moment).',
    );
  }

  static String weeklyTitle(String locale) => _t(
        locale,
        es: 'Resumen de tu tocador',
        en: 'Vanity check-in',
        ru: 'Обзор коллекции',
      );

  static String weeklyBody(String locale, int count) => _t(
        locale,
        es: 'Tienes $count producto(s) que caducan en los próximos 30 días.',
        en: 'You have $count product(s) expiring in the next 30 days.',
        ru: 'У вас $count продукт(ов) с истекающим сроком в ближайшие 30 дней.',
      );

  static String _t(String locale, {required String es, required String en, required String ru}) {
    switch (locale) {
      case 'en':
        return en;
      case 'ru':
        return ru;
      default:
        return es;
    }
  }
}
