import 'package:equatable/equatable.dart';
import 'package:podkes_app/shared/entities/episode_entity.dart';

class PodcastEntity extends Equatable {
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
  final List<EpisodeEntity> episodes;

  const PodcastEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.duration,
    required this.audioUrl,
    required this.description,
    required this.categoryId,
    this.isFavorite = false,
    this.isTrend = false,
    this.episodes = const [],
  });

  @override
  List<Object?> get props => [id, isFavorite, isTrend, episodes];

  PodcastEntity copyWith({
    String? id,
    String? title,
    String? author,
    String? imageUrl,
    Duration? duration,
    String? audioUrl,
    String? description,
    String? categoryId,
    bool? isFavorite,
    bool? isTrend,
    List<EpisodeEntity>? episodes,
  }) {
    return PodcastEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      audioUrl: audioUrl ?? this.audioUrl,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      isTrend: isTrend ?? this.isTrend,
      episodes: episodes ?? this.episodes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'duration': duration.inSeconds,
      'audioUrl': audioUrl,
      'description': description,
      'categoryId': categoryId,
      'isFavorite': isFavorite,
      'isTrend': isTrend,
    };
  }

  factory PodcastEntity.fromMap(Map<String, dynamic> map) {
    return PodcastEntity(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      duration: Duration(seconds: map['duration'] ?? 0),
      audioUrl: map['audioUrl'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      isTrend: map['isTrend'] ?? false,
    );
  }
}