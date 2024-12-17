import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volkov_flutter_test_app/data/repositories/weather_repository.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/bloc/bloc.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ПИбд-33 Волков Никита',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: RepositoryProvider<WeatherRepository>(
        lazy: true,
        create: (_) => WeatherRepository(),
        child: BlocProvider<HomeBloc>(
          lazy: false,
          create: (context) => HomeBloc(context.read<WeatherRepository>()),
          child: const HomePage(),
        ),
      ),
    );
  }
}
