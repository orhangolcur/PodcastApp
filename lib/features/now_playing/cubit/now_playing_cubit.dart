import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart'; // Paketi ekledik
import '../../../shared/entities/podcast_entitiy.dart';
import '../../../shared/entities/episode_entity.dart';
import 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  NowPlayingCubit() : super(NowPlayingInitial()) {
    _listenToPlayerStreams();
  }

  void _listenToPlayerStreams() {
    _audioPlayer.playerStateStream.listen((playerState) {
      if (state is NowPlayingLoaded) {
        final currentState = state as NowPlayingLoaded;
        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;

        emit(currentState.copyWith(
          isPlaying: isPlaying,
          isBuffering: processingState == ProcessingState.buffering ||
              processingState == ProcessingState.loading,
        ));
      }
    });

    _audioPlayer.positionStream.listen((newPosition) {
      if (state is NowPlayingLoaded) {
        emit((state as NowPlayingLoaded).copyWith(position: newPosition));
      }
    });

    _audioPlayer.durationStream.listen((newDuration) {
      if (state is NowPlayingLoaded && newDuration != null) {
        emit((state as NowPlayingLoaded).copyWith(duration: newDuration));
      }
    });
  }

  Future<void> playEpisode(PodcastEntity podcast, EpisodeEntity episode) async {
    final isSameEpisode = state is NowPlayingLoaded &&
        (state as NowPlayingLoaded).currentEpisode?.id == episode.id;

    if (isSameEpisode) {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
      return;
    }

    emit(NowPlayingLoaded(
      podcast: podcast,
      currentEpisode: episode,
      isBuffering: true,
    ));

    try {
      if (episode.audioUrl.isNotEmpty) {
        await _audioPlayer.setUrl(episode.audioUrl);
        await _audioPlayer.play();
      } else {
        print("Hata: Audio URL boş!");
      }
    } catch (e) {
      print("Oynatma hatası: $e");
    }
  }

  void play() => _audioPlayer.play();

  void pause() => _audioPlayer.pause();

  void seek(Duration position) => _audioPlayer.seek(position);

  void setPodcast(PodcastEntity podcast) {
    if (state is NowPlayingLoaded) {
      final currentState = state as NowPlayingLoaded;
      if (currentState.podcast.id == podcast.id) return;
    }
    emit(NowPlayingLoaded(podcast: podcast));
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}