import 'package:podkes_app/shared/entities/podcast_entitiy.dart';

abstract class PodcastRepository {
  Future<List<PodcastEntity>> getPodcasts();
  Future<List<PodcastEntity>> searchPodcasts(String query);
  Future<bool> toggleFavorite(String podcastId);
  Future<List<String>> getMySubscriptionIds();
  Future<List<PodcastEntity>> getFavoritePodcasts();
  void resetSession();
}