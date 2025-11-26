import 'package:flutter/cupertino.dart';
import 'package:podkes_app/core/network/api_client.dart';
import 'package:podkes_app/shared/models/podcast_model.dart';
import 'package:podkes_app/shared/repositories/podcast/podcast_repository.dart';
import '../../entities/podcast_entitiy.dart';

class PodcastApiRepository implements PodcastRepository {
  final ApiClient _apiClient;

  PodcastApiRepository(this._apiClient);

  @override
  Future<List<PodcastEntity>> getPodcasts() async {
    try {
      final response = await _apiClient.get('/Podcasts');

      if (response is! List) {
        throw Exception('Beklenmeyen veri formatı: Liste bekleniyordu.');
      }

      final podcasts = response.map((item) {
        return PodcastModel.fromJson(item).toEntity();
      }).toList();

      return podcasts;
    } catch (e) {
      print('Podcast verisi alınırken hata oluştu: $e');
      throw Exception('Podcast listesi yüklenemedi.');
    }
  }

  @override
  Future<bool> toggleFavorite(String podcastId) async {
    try {
      final response = await _apiClient.post('/Subscriptions/$podcastId');

      if (response != null && response['subscribed'] != null) {
        return response['subscribed'];
      }
      return false;
    } catch (e) {
      print('Favori işlemi hatası: $e');
      return false;
    }
  }

  @override
  Future<List<String>> getMySubscriptionIds() async {
    try {
      final response = await _apiClient.get('/Subscriptions');

      if (response is List) {
        final ids = response.map((e) => e['id'].toString()).toList();
        return ids;
      }

      debugPrint("Cevap bir liste değil!");
      return [];

    } catch (e) {
      debugPrint("Favorileri çekerken hata: $e");
      return [];
    }
  }

  @override
  Future<List<PodcastEntity>> getFavoritePodcasts() async {
    try {
      final response = await _apiClient.get('/Subscriptions');

      if (response is! List) return [];

      return response.map((item) {
        return PodcastModel.fromJson(item).toEntity();
      }).toList();
    } catch (e) {
      debugPrint('Favori listesi çekilemedi: $e');
      return [];
    }
  }
}