import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../favorites/cubit/favorite_cubit.dart';
import '../../../now_playing/cubit/now_playing_cubit.dart';
import '../../cubit/discover_state.dart';

class PodcastGrid extends StatelessWidget {
  final DiscoverLoaded? state;
  final bool isLoading;

  const PodcastGrid({super.key, required this.state, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final podcasts = state?.displayPodcasts ?? [];

    if (isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, __) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF262033),
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 16.h,
                  color: Colors.white12,
                ),
                SizedBox(height: 4.h),
                Container(
                  height: 14.h,
                  color: Colors.white12,
                ),
              ],
            ),
          );
        },
      );
    }

    if (podcasts.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 32.h),
        child: const Center(
          child: Text(
            'No podcasts found',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double aspectRatio;
        double width = constraints.maxWidth;

        if (width > 900) {
          crossAxisCount = 4;
          aspectRatio = 0.75;
        } else if (width > 600) {
          crossAxisCount = 3;
          aspectRatio = 0.55;
        } else {
          crossAxisCount = 2;
          aspectRatio = 0.75;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: podcasts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            final podcast = podcasts[index];
            final isFav = context.watch<FavoriteCubit>().isFavorite(podcast);

            return GestureDetector(
              onTap: () {
                context.read<NowPlayingCubit>().setPodcast(podcast);
                context.push('/now-playing');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF262033),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              podcast.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: SizedBox(
                                    width: 24.w,
                                    height: 24.w,
                                    child: const CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, color: Colors.white38),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6.h,
                          right: 6.w,
                          child: GestureDetector(
                            onTap: () {
                              context.read<FavoriteCubit>().toggleFavorite(podcast);
                            },
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.redAccent : Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Flexible(
                      child: Text(
                        podcast.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Flexible(
                      child: Text(
                        podcast.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}