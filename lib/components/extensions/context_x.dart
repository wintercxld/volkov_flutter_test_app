import 'package:flutter/widgets.dart';
import 'package:volkov_flutter_test_app/components/locale/l10n/app_locale.dart';

extension LocalContextX on BuildContext {
  AppLocale get locale => AppLocale.of(this)!;
}
