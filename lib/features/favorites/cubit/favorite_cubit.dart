import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podkes_app/shared/entities/podcast_entitiy.dart';
import 'package:podkes_app/shared/repositories/podcast/podcast_repository.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final PodcastRepository _repository;

  FavoriteCubit(this._repository) : super(FavoriteState([])) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final ids = await _repository.getMySubscriptionIds();
      emit(FavoriteState(ids));
    } catch (e) {
      print("Favoriler yüklenemedi: $e");
      emit(FavoriteState([]));
    }
  }

  bool isFavorite(PodcastEntity podcast) {
    return state.favoriteIds.any((id) => id.toLowerCase() == podcast.id.toLowerCase());
  }

  Future<void> toggleFavorite(PodcastEntity podcast) async {
    final String id = podcast.id;
    final optimisticList = List<String>.from(state.favoriteIds);

    if (isFavorite(podcast)) {
      optimisticList.removeWhere((e) => e.toLowerCase() == id.toLowerCase());
    } else {
      optimisticList.add(id);
    }
    emit(FavoriteState(optimisticList));

    try {
      await _repository.toggleFavorite(id);
    } catch (e) {
      debugPrint("Hata oluştu, eski haline dönülüyor: $e");
      await loadFavorites();
    }
  }

  void resetState() {
    emit(FavoriteState([]));
  }

  Future<void> refreshFavorites() async {
    resetState();
    await loadFavorites();
  }
}