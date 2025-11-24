import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:podkes_app/features/now_playing/cubit/now_playing_cubit.dart';
import '../../../shared/entities/podcast_entitiy.dart';

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
                        Text(
                          podcast.title,
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