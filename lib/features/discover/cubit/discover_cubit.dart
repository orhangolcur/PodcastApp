import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podkes_app/shared/repositories/podcast/podcast_repository.dart';
import '../../../shared/entities/podcast_entitiy.dart';
import 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  final PodcastRepository _repository;

  List<PodcastEntity> _allPodcasts = [];
  String selectedCategoryId = 'All';
  Timer? _debounce;

  DiscoverCubit(this._repository) : super(DiscoverInitial()) {
    loadPodcasts();
  }

  Future<void> loadPodcasts() async {
    emit(DiscoverLoading());
    try {
      _allPodcasts = await _repository.getPodcasts();

      emit(DiscoverLoaded(
          allPodcasts: _allPodcasts,
          displayPodcasts: _allPodcasts,
          selectedCategory: 'All'
      ));
    } catch (e) {
      emit(DiscoverError("Podcastler yüklenemedi: $e"));
    }
  }

  void selectCategory(String categoryId) {
    if (state is DiscoverLoaded) {
      final currentState = state as DiscoverLoaded;
      selectedCategoryId = categoryId;

      List<PodcastEntity> filteredList;

      if (categoryId == 'All') {
        filteredList = currentState.allPodcasts;
      } else {
        filteredList = currentState.allPodcasts
            .where((p) => p.author == categoryId)
            .toList();
      }

      emit(currentState.copyWith(
        selectedCategory: categoryId,
        displayPodcasts: filteredList,
      ));
    }
  }

  void updateSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {

      if (query.isEmpty) {
        selectCategory(selectedCategoryId);
        return;
      }

      if (state is DiscoverLoaded) {

        try {
          final searchResults = await _repository.searchPodcasts(query);

          final currentState = state as DiscoverLoaded;

          emit(currentState.copyWith(
            displayPodcasts: searchResults,
          ));

        } catch (e) {
          print("Arama hatası: $e");
        }
      }
    });
  }

  Future<void> toggleFavorite(String podcastId) async {
    if (state is DiscoverLoaded) {
      final currentState = state as DiscoverLoaded;

      final updatedList = currentState.displayPodcasts.map((p) {
        if (p.id == podcastId) {
          return p.copyWith(isFavorite: !p.isFavorite);
        }
        return p;
      }).toList();

      emit(currentState.copyWith(displayPodcasts: updatedList));

      await _repository.toggleFavorite(podcastId);
    }
  }
}