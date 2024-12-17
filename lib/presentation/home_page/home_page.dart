import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volkov_flutter_test_app/components/utils/debounce.dart';
import 'package:volkov_flutter_test_app/domain/models/card.dart';
import 'package:volkov_flutter_test_app/presentation/details_page/details_page.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/bloc/bloc.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/bloc/events.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/bloc/state.dart';

part 'card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _Body());
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const HomeLoadDataEvent());
    });

    scrollController.addListener(_onNextPageListener);

    super.initState();
  }

  void _onNextPageListener() {
    if (scrollController.offset > scrollController.position.maxScrollExtent) {
      final bloc = context.read<HomeBloc>();
      if (!bloc.state.isPaginationLoading) {
        bloc.add(HomeLoadDataEvent(
          search: searchController.text,
          nextPage: bloc.state.data?.nextPage,
        ));
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // late Future<List<CardData>?> searchData;
  // final searchController = TextEditingController();
  // final repo = WeatherRepository();
  //
  // final Set<String> favoriteCities = {};
  // List<String> trustedCities = [
  //   'New York',
  //   'London',
  //   'Paris',
  //   'Berlin',
  //   'Moscow',
  //   'Tokyo',
  //   'Sydney',
  //   'Los Angeles',
  //   'Chicago',
  //   'San Francisco',
  //   'Rome',
  //   'Barcelona',
  //   'Dubai'
  // ];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _loadTrustedCitiesWeather();
  // }
  //
  // void _loadTrustedCitiesWeather() {
  //   searchData = repo.getWeatherForCities(
  //     cities: trustedCities,
  //     onError: (e) => showErrorDialog(context, error: e),
  //   );
  // }
  //
  // void _updateSearchData(String search) {
  //   searchData = repo.loadData(q: search);
  //   setState(() {});
  // }
  //
  // void _toggleFavorite(String city) {
  //   setState(() {
  //     if (favoriteCities.contains(city)) {
  //       favoriteCities.remove(city);
  //     } else {
  //       favoriteCities.add(city);
  //     }
  //   });
  // }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: CupertinoSearchTextField(
              controller: searchController,
              onChanged: (search) {
                Debounce.run(() => context
                    .read<HomeBloc>()
                    .add(HomeLoadDataEvent(search: search)));
              },
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => state.error != null
                ? Text(
                    state.error ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.red),
                  )
                : state.isLoading
                    ? const CircularProgressIndicator()
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: state.data?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final data = state.data?.data?[index];
                              return data != null
                                  ? _Card.fromData(
                                      data,
                                      onFavorite: (title, isFavorite) =>
                                          _showSnackBar(
                                              context, title, isFavorite),
                                      onTap: () => _navToDetails(context, data),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => state.isPaginationLoading
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() {
    context
        .read<HomeBloc>()
        .add(HomeLoadDataEvent(search: searchController.text));
    return Future.value(null);
  }

  void _navToDetails(BuildContext context, CardData data) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => DetailsPage(data)),
    );
  }

  void _showSnackBar(BuildContext context, String title, bool isFavorite) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '$title ${isFavorite ? 'в избранном!' : 'не в избранном :('}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        backgroundColor: Colors.orangeAccent,
        duration: const Duration(seconds: 1),
      ));
    });
  }
}
