import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'favorite_state.g.dart';

@CopyWith()
class FavoriteState extends Equatable {
  final List<String>? favoritedIds;

  const FavoriteState({required this.favoritedIds});

  @override
  List<Object?> get props => [favoritedIds];
}
