import '../../../shared/entities/podcast_entitiy.dart';

abstract class DiscoverState {}

class DiscoverInitial extends DiscoverState {}

class DiscoverLoading extends DiscoverState {}

class DiscoverLoaded extends DiscoverState {
  final List<PodcastEntity> allPodcasts;
  final List<PodcastEntity> displayPodcasts;
  final String selectedCategory;

  DiscoverLoaded({
    required this.allPodcasts,
    required this.displayPodcasts,
    this.selectedCategory = 'All',
  });

  DiscoverLoaded copyWith({
    List<PodcastEntity>? allPodcasts,
    List<PodcastEntity>? displayPodcasts,
    String? selectedCategory,
  }) {
    return DiscoverLoaded(
      allPodcasts: allPodcasts ?? this.allPodcasts,
      displayPodcasts: displayPodcasts ?? this.displayPodcasts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class DiscoverError extends DiscoverState {
  final String message;
  DiscoverError(this.message);
}