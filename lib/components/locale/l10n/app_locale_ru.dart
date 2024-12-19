import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocaleRu extends AppLocale {
  AppLocaleRu([String locale = 'ru']) : super(locale);

  @override
  String get search => 'Поиск';

  @override
  String get favorited => 'в избранном!';

  @override
  String get unfavorited => 'не в избранном :(';

  @override
  String get arbEnding => 'Чтобы не забыть про отсутствие запятой :)';
}
