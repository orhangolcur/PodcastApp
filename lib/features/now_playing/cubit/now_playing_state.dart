import 'package:podkes_app/shared/entities/podcast_entitiy.dart';
import 'package:podkes_app/shared/entities/episode_entity.dart';

abstract class NowPlayingState {}

class NowPlayingInitial extends NowPlayingState {}

class NowPlayingLoaded extends NowPlayingState {
  final PodcastEntity podcast;
  final EpisodeEntity? currentEpisode;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isBuffering;

  NowPlayingLoaded({
    required this.podcast,
    this.currentEpisode,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isBuffering = false,
  });

  NowPlayingLoaded copyWith({
    PodcastEntity? podcast,
    EpisodeEntity? currentEpisode,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isBuffering,
  }) {
    return NowPlayingLoaded(
      podcast: podcast ?? this.podcast,
      currentEpisode: currentEpisode ?? this.currentEpisode,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isBuffering: isBuffering ?? this.isBuffering,
    );
  }
}