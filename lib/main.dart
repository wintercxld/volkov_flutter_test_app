import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volkov_flutter_test_app/components/locale/l10n/app_locale.dart';
import 'package:volkov_flutter_test_app/data/repositories/weather_repository.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/bloc/bloc.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/home_page.dart';
import 'package:volkov_flutter_test_app/presentation/favorite_bloc/favorite_bloc.dart';
import 'package:volkov_flutter_test_app/presentation/locale_bloc/locale_bloc.dart';
import 'package:volkov_flutter_test_app/presentation/locale_bloc/locale_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleBloc>(
      lazy: false,
      create: (context) => LocaleBloc(Locale(Platform.localeName)),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'ПИбд-33 Волков Никита',
            locale: state.currentLocale,
            localizationsDelegates: AppLocale.localizationsDelegates,
            supportedLocales: AppLocale.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
              useMaterial3: true,
            ),
            home: RepositoryProvider<WeatherRepository>(
              lazy: true,
              create: (_) => WeatherRepository(),
              child: BlocProvider<FavoriteBloc>(
                lazy: false,
                create: (context) => FavoriteBloc(),
                child: BlocProvider<HomeBloc>(
                  lazy: false,
                  create: (context) =>
                      HomeBloc(context.read<WeatherRepository>()),
                  child: const HomePage(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
