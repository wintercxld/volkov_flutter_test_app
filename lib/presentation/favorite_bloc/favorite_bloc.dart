import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volkov_flutter_test_app/presentation/favorite_bloc/favorite_event.dart';
import 'package:volkov_flutter_test_app/presentation/favorite_bloc/favorite_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _favoritedPrefsKey = 'favorited';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState(favoritedIds: [])) {
    on<ChangeFavoriteEvent>(_onChangefavorite);
    on<LoadFavoritesEvent>(_onLoadFavorites);
  }

  Future<void> _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_favoritedPrefsKey);

    emit(state.copyWith(favoritedIds: data));
  }

  Future<void> _onChangefavorite(
      ChangeFavoriteEvent event, Emitter<FavoriteState> emit) async {
    final updatedList = List<String>.from(state.favoritedIds ?? []);

    if (updatedList.contains(event.id)) {
      updatedList.remove(event.id);
    } else {
      updatedList.add(event.id);
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_favoritedPrefsKey, updatedList);

    emit(state.copyWith(favoritedIds: updatedList));
  }
}
