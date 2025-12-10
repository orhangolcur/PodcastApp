import 'package:equatable/equatable.dart';
import '../entities/episode_entity.dart';

class EpisodeModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String audioUrl;
  final double durationMinutes;
  final String publishedDate;

  const EpisodeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.durationMinutes,
    required this.publishedDate,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Başlıksız Bölüm',
      description: json['description'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toDouble() ?? 0.0,
      publishedDate: json['publishedDate'] ?? '',
    );
  }

  factory EpisodeModel.fromEntity(EpisodeEntity entity) {
    return EpisodeModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      audioUrl: entity.audioUrl,
      durationMinutes: entity.duration.inMinutes.toDouble(),
      publishedDate: entity.publishedDate?.toIso8601String() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'audioUrl': audioUrl,
      'durationMinutes': durationMinutes,
      'publishedDate': publishedDate,
    };
  }

  EpisodeEntity toEntity() {
    return EpisodeEntity(
      id: id,
      title: title,
      description: description,
      audioUrl: audioUrl,
      duration: Duration(minutes: durationMinutes.toInt()),
      publishedDate: DateTime.tryParse(publishedDate),
    );
  }

  @override
  List<Object?> get props => [id, title, audioUrl, durationMinutes];
}