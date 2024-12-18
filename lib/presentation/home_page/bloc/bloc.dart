import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volkov_flutter_test_app/data/repositories/weather_repository.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/bloc/events.dart';
import 'package:volkov_flutter_test_app/presentation/home_page/bloc/state.dart';
import 'package:volkov_flutter_test_app/domain/models/home.dart';
import 'package:volkov_flutter_test_app/domain/models/card.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WeatherRepository repo;

  HomeBloc(this.repo) : super(const HomeState()) {
    on<HomeLoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
      HomeLoadDataEvent event, Emitter<HomeState> emit) async {
    if (event.nextPage == null) {
      emit(state.copyWith(isLoading: true, error: null));
    } else {
      emit(state.copyWith(isPaginationLoading: true, error: null));
    }

    String? error;

    try {
      final List<CardData> cardDataList = await repo.getWeatherForPage(
        page: event.nextPage ?? 1,
        pageSize: 10,
        search: event.search,
        onError: (e) => error = e,
      );

      final HomeData newData;

      if (event.nextPage != null && state.data != null) {
        newData = HomeData(
          data: [...(state.data?.data ?? []), ...cardDataList],
          nextPage: (cardDataList.isNotEmpty) ? (event.nextPage! + 1) : null,
        );
      } else {
        newData = HomeData(
          data: cardDataList,
          nextPage: cardDataList.isNotEmpty ? 2 : null,
        );
      }

      emit(state.copyWith(
        isLoading: false,
        isPaginationLoading: false,
        data: newData,
        error: error,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isPaginationLoading: false,
        error: e.toString(),
      ));
    }
  }
}
