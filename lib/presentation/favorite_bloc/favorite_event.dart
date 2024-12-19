abstract class FavoriteEvent {
  const FavoriteEvent();
}

class LoadFavoritesEvent extends FavoriteEvent {
  const LoadFavoritesEvent();
}

class ChangeFavoriteEvent extends FavoriteEvent {
  final String id;

  const ChangeFavoriteEvent(this.id);
}
