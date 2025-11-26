import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:podkes_app/shared/entities/podcast_entitiy.dart';
import '../../../now_playing/cubit/now_playing_cubit.dart';
import '../../cubit/favorite_cubit.dart';

class FavoriteListItem extends StatelessWidget {
  final PodcastEntity podcast;

  const FavoriteListItem({super.key, required this.podcast});

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape =
        MediaQuery.of(context).size.width > 600 && MediaQuery.of(context).orientation == Orientation.landscape;

    return Dismissible(
      key: ValueKey(podcast.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: Colors.redAccent,
        child: Icon(Icons.delete, color: Colors.white, size: 24.sp),
      ),
      onDismissed: (_) {
        context.read<FavoriteCubit>().toggleFavorite(podcast);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${podcast.title} removed from favorites',
              style: TextStyle(fontSize: 14.sp),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xFF262033),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                podcast.imageUrl,
                width: 60.w,
                height: 60.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.podcasts, color: Colors.white38, size: 30.sp),
              ),
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcast.title,
                    style: TextStyle(
                      fontSize: isTabletLandscape ? 13.sp : 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    podcast.author,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                context.read<NowPlayingCubit>().setPodcast(podcast);
                context.push('/podcast-details', extra: podcast);
              },
              icon: Icon(Icons.play_arrow, color: Colors.white, size: 24.sp),
              tooltip: 'Play',
            ),
          ],
        ),
      ),
    );
  }
}
