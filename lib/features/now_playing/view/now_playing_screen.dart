import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/entities/podcast_entitiy.dart';
import '../../favorites/cubit/favorite_cubit.dart';
import '../../favorites/cubit/favorite_state.dart';
import '../cubit/now_playing_cubit.dart';
import '../cubit/now_playing_state.dart';

class NowPlayingScreen extends StatelessWidget {
  final PodcastEntity podcast;

  const NowPlayingScreen({super.key, required this.podcast});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingCubit, NowPlayingState>(
      builder: (context, state) {
        if (state is! NowPlayingLoaded) {
          return const Scaffold(
            backgroundColor: Color(0xFF1C1B2D),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final loadedState = state;
        final isPlaying = loadedState.isPlaying;
        final position = loadedState.position;
        final duration = loadedState.duration;
        final currentEpisode = loadedState.currentEpisode;
        final isBuffering = loadedState.isBuffering;

        return Scaffold(
          backgroundColor: const Color(0xFF1C1B2D),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
              onPressed: () => context.pop(),
            ),
            title: Text(
              currentEpisode?.title ?? podcast.title,
              style: TextStyle(fontSize: 16.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
            actions: [
              BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, favState) {
                  final isFav = context.read<FavoriteCubit>().isFavorite(podcast);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                      size: 24.sp,
                    ),
                    onPressed: () {
                      context.read<FavoriteCubit>().toggleFavorite(podcast);
                    },
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600.w),
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: SizedBox(
                            width: 0.7.sw,
                            height: 0.7.sw,
                            child: Image.network(
                              podcast.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.podcasts,
                                color: Colors.white30,
                                size: 64.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        Text(
                          currentEpisode?.title ?? "Bölüm Seçilmedi",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          podcast.title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        Slider(
                          value: duration.inSeconds > 0
                              ? position.inSeconds
                              .clamp(0, duration.inSeconds)
                              .toDouble()
                              : 0.0,
                          max: duration.inSeconds > 0
                              ? duration.inSeconds.toDouble()
                              : 1.0,
                          activeColor: Colors.white,
                          inactiveColor: Colors.white24,
                          onChanged: (value) {
                            context
                                .read<NowPlayingCubit>()
                                .seek(Duration(seconds: value.toInt()));
                          },
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12.sp),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 32.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay_10,
                                  color: Colors.white),
                              iconSize: 32.sp,
                              onPressed: () {
                                context.read<NowPlayingCubit>().seek(
                                    position - const Duration(seconds: 10));
                              },
                            ),
                            SizedBox(width: 20.w),

                            Container(
                              width: 64.w,
                              height: 64.w,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: isBuffering
                                  ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                    color: Colors.black),
                              )
                                  : IconButton(
                                icon: Icon(
                                  isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.black,
                                  size: 32.sp,
                                ),
                                onPressed: () {
                                  final cubit =
                                  context.read<NowPlayingCubit>();
                                  if (isPlaying) {
                                    cubit.pause();
                                  } else {
                                    cubit.play();
                                  }
                                },
                              ),
                            ),

                            SizedBox(width: 20.w),

                            IconButton(
                              icon: const Icon(Icons.forward_10,
                                  color: Colors.white),
                              iconSize: 32.sp,
                              onPressed: () {
                                context.read<NowPlayingCubit>().seek(
                                    position + const Duration(seconds: 10));
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}