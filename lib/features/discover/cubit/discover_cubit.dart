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
        selectedCategory: 'All',
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
        filteredList = _allPodcasts;
      } else {
        filteredList = _allPodcasts
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

      final updatedDisplayList = currentState.displayPodcasts.map((p) {
        if (p.id == podcastId) {
          return p.copyWith(isFavorite: !p.isFavorite);
        }
        return p;
      }).toList();

      _allPodcasts = _allPodcasts.map((p) {
        if (p.id == podcastId) {
          return p.copyWith(isFavorite: !p.isFavorite);
        }
        return p;
      }).toList();
      emit(currentState.copyWith(
        displayPodcasts: updatedDisplayList,
        allPodcasts: _allPodcasts,
      ));

      try {
        await _repository.toggleFavorite(podcastId);
      } catch (e) {
        print("Favori hatası: $e");
      }
    }
  }

  void resetState() {
    _allPodcasts = [];
    selectedCategoryId = 'All';
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _repository.resetSession();
    emit(DiscoverInitial());
  }

  Future<void> refreshPodcasts() async {
    resetState();
    await loadPodcasts();
  }
}