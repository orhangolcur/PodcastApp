import 'package:equatable/equatable.dart';
import 'package:podkes_app/shared/models/episode_model.dart';
import '../entities/podcast_entitiy.dart';

class PodcastModel extends Equatable {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final Duration duration;
  final String audioUrl;
  final String description;
  final String categoryId;
  final bool isFavorite;
  final bool isTrend;
  final List<EpisodeModel> episodes;

  const PodcastModel({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.duration,
    required this.audioUrl,
    required this.description,
    required this.categoryId,
    required this.isFavorite,
    this.isTrend = false,
    this.episodes = const [],
  });

  factory PodcastModel.fromJson(Map<String, dynamic> json) {
    var episodesList = <EpisodeModel>[];
    if (json['episodes'] != null) {
      episodesList = (json['episodes'] as List)
          .map((e) => EpisodeModel.fromJson(e))
          .toList();
    }
    return PodcastModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      author: json['category'] ?? 'Genel',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
      duration: episodesList.isNotEmpty
          ? Duration(minutes: episodesList.first.durationMinutes.toInt())
          : const Duration(seconds: 0),
      audioUrl: episodesList.isNotEmpty ? episodesList.first.audioUrl : '',
      description: json['description'] ?? '',
      categoryId: json['category'] ?? 'Genel',
      isFavorite: json['isFavorite'] ?? false,
      isTrend: json['isTrend'] ?? false,
      episodes: episodesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': categoryId,
      'isTrend': isTrend,
      'isFavorite': isFavorite,
    };
  }

  PodcastModel copyWith({
    String? id,
    String? title,
    String? author,
    String? imageUrl,
    Duration? duration,
    String? audioUrl,
    String? description,
    String? categoryId,
    bool? isTrend,
    bool? isFavorite,
  }) {
    return PodcastModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      audioUrl: audioUrl ?? this.audioUrl,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      isTrend: isTrend ?? this.isTrend,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory PodcastModel.fromEntity(PodcastEntity entity) {
    return PodcastModel(
      id: entity.id,
      title: entity.title,
      author: entity.author,
      imageUrl: entity.imageUrl,
      duration: entity.duration,
      audioUrl: entity.audioUrl,
      description: entity.description,
      categoryId: entity.categoryId,
      isTrend: entity.isTrend,
      isFavorite: entity.isFavorite,
    );
  }

  @override
  List<Object> get props => [id, title, author, categoryId, isTrend, isFavorite];

  @override
  String toString() {
    return 'PodcastModel(title: $title, category: $author, isTrend: $isTrend, isFav: $isFavorite)';
  }
}

extension PodcastMapper on PodcastModel {
  PodcastEntity toEntity() => PodcastEntity(
    id: id,
    title: title,
    author: author,
    imageUrl: imageUrl,
    duration: duration,
    audioUrl: audioUrl,
    description: description,
    categoryId: categoryId,
    isFavorite: isFavorite,
    isTrend: isTrend,
    episodes: episodes.map((e) => e.toEntity()).toList(),
  );
}