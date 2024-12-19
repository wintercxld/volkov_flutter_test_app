import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volkov_flutter_test_app/components/extensions/context_x.dart';
import 'package:volkov_flutter_test_app/components/utils/debounce.dart';
import 'package:volkov_flutter_test_app/domain/models/card.dart';
import 'package:volkov_flutter_test_app/presentation/details_page/details_page.dart';
import 'package:volkov_flutter_test_app/presentation/favorite_bloc/favorite_bloc.dart';
import 'package:volkov_flutter_test_app/presentation/favorite_bloc/favorite_event.dart';
import 'package:volkov_flutter_test_app/presentation/favorite_bloc/favorite_state.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/bloc/bloc.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/bloc/events.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/bloc/state.dart';
import 'package:volkov_flutter_test_app/presentation/locale_bloc/locale_bloc.dart';
import 'package:volkov_flutter_test_app/presentation/locale_bloc/locale_events.dart';
import 'package:volkov_flutter_test_app/presentation/locale_bloc/locale_state.dart';

import '../common/svg_objects.dart';

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
      context.read<FavoriteBloc>().add(const LoadFavoritesEvent());
    });

    scrollController.addListener(_onNextPageListener);

    super.initState();
  }

  void _onNextPageListener() {
    if (scrollController.offset >
        scrollController.position.maxScrollExtent - 10) {
      final bloc = context.read<HomeBloc>();
      if (!bloc.state.isPaginationLoading &&
          bloc.state.data?.nextPage != null) {
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

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CupertinoSearchTextField(
                    controller: searchController,
                    placeholder: context.locale.search,
                    onChanged: (search) {
                      Debounce.run(() => context
                          .read<HomeBloc>()
                          .add(HomeLoadDataEvent(search: search)));
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.read<LocaleBloc>().add(const ChangeLocaleEvent()),
                child: SizedBox.square(
                  dimension: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: BlocBuilder<LocaleBloc, LocaleState>(
                      builder: (context, state) {
                        return state.currentLocale.languageCode == 'ru'
                            ? const SvgRu()
                            : const SvgUk();
                      },
                    ),
                  ),
                ),
              ),
            ],
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
                    : BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, FavoriteState) {
                          return Expanded(
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
                                          onFavorite: _onFavorite,
                                          isFavorited: FavoriteState
                                                  .favoritedIds
                                                  ?.contains(data.id) ==
                                              true,
                                          onTap: () =>
                                              _navToDetails(context, data),
                                        )
                                      : const SizedBox.shrink();
                                },
                              ),
                            ),
                          );
                        },
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

  void _onFavorite(String? id, String title, bool isFavorited) {
    if (id != null) {
      context.read<FavoriteBloc>().add(ChangeFavoriteEvent(id));
      _showSnackBar(context, title, !isFavorited);
    }
  }

  void _showSnackBar(BuildContext context, String title, bool isFavorite) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '$title ${isFavorite ? context.locale.favorited : context.locale.unfavorited}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        backgroundColor: Colors.orangeAccent,
        duration: const Duration(seconds: 1),
      ));
    });
  }
}
