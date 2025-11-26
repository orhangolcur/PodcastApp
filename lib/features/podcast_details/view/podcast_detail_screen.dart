import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:podkes_app/features/now_playing/cubit/now_playing_cubit.dart';
import '../../../shared/entities/podcast_entitiy.dart';
import '../../favorites/cubit/favorite_cubit.dart';
import '../../favorites/cubit/favorite_state.dart';

class PodcastDetailScreen extends StatelessWidget {
  final PodcastEntity podcast;

  const PodcastDetailScreen({super.key, required this.podcast});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2D),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            backgroundColor: const Color(0xFF1C1B2D),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    podcast.imageUrl,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.5),
                    colorBlendMode: BlendMode.darken,
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    podcast.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    podcast.author,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            BlocBuilder<FavoriteCubit, FavoriteState>(
                              builder: (context, state) {
                                final isFav = context.read<FavoriteCubit>().isFavorite(podcast);

                                return GestureDetector(
                                  onTap: () {
                                    context.read<FavoriteCubit>().toggleFavorite(podcast);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: isFav ? Colors.white : const Color(0xFF6C63FF),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: isFav ? Border.all(color: Colors.white) : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isFav ? Icons.check : Icons.add,
                                          color: isFav ? Colors.black : Colors.white,
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          isFav ? "Following" : "Follow",
                                          style: TextStyle(
                                            color: isFav ? Colors.black : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          podcast.episodes.isEmpty
              ? SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: const Text(
                "Henüz bölüm yüklenmemiş.",
                style: TextStyle(color: Colors.white54),
                textAlign: TextAlign.center,
              ),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final episode = podcast.episodes[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  title: Text(
                    episode.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    episode.publishedDate != null
                        ? "${episode.publishedDate!.day}.${episode.publishedDate!.month}.${episode.publishedDate!.year}"
                        : "Tarih yok",
                    style: const TextStyle(color: Colors.white38),
                  ),
                  trailing: const Icon(Icons.play_circle_outline, color: Colors.white, size: 32),
                  onTap: () {
                    context.read<NowPlayingCubit>().playEpisode(podcast, episode);
                    context.push('/now-playing');
                  },
                );
              },
              childCount: podcast.episodes.length,
            ),
          ),
        ],
      ),
    );
  }
}