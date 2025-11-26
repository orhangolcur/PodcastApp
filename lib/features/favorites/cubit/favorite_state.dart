import 'package:equatable/equatable.dart';

class FavoriteState extends Equatable {
  final List<String> favoriteIds;

  const FavoriteState(this.favoriteIds);

  @override
  List<Object?> get props => [favoriteIds];
}