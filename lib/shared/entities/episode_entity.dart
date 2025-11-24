import 'package:equatable/equatable.dart';

class EpisodeEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String audioUrl;
  final Duration duration;
  final DateTime? publishedDate;

  const EpisodeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.duration,
    this.publishedDate,
  });

  @override
  List<Object?> get props => [id, title, audioUrl];
}