// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FavoriteStateCWProxy {
  FavoriteState favoritedIds(List<String>? favoritedIds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FavoriteState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FavoriteState(...).copyWith(id: 12, name: "My name")
  /// ````
  FavoriteState call({
    List<String>? favoritedIds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFavoriteState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFavoriteState.copyWith.fieldName(...)`
class _$FavoriteStateCWProxyImpl implements _$FavoriteStateCWProxy {
  const _$FavoriteStateCWProxyImpl(this._value);

  final FavoriteState _value;

  @override
  FavoriteState favoritedIds(List<String>? favoritedIds) =>
      this(favoritedIds: favoritedIds);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FavoriteState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FavoriteState(...).copyWith(id: 12, name: "My name")
  /// ````
  FavoriteState call({
    Object? favoritedIds = const $CopyWithPlaceholder(),
  }) {
    return FavoriteState(
      favoritedIds: favoritedIds == const $CopyWithPlaceholder()
          ? _value.favoritedIds
          // ignore: cast_nullable_to_non_nullable
          : favoritedIds as List<String>?,
    );
  }
}

extension $FavoriteStateCopyWith on FavoriteState {
  /// Returns a callable class that can be used as follows: `instanceOfFavoriteState.copyWith(...)` or like so:`instanceOfFavoriteState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FavoriteStateCWProxy get copyWith => _$FavoriteStateCWProxyImpl(this);
}
