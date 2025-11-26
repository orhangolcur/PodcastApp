import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:podkes_app/core/network/api_client.dart';
import 'package:podkes_app/shared/entities/podcast_entitiy.dart';
import 'package:podkes_app/shared/repositories/podcast/podcast_api_repository.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _repository = PodcastApiRepository(ApiClient(baseUrl: 'http://10.0.2.2:5269/api'));

  List<PodcastEntity> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final podcasts = await _repository.getFavoritePodcasts();
    if (mounted) {
      setState(() {
        _favorites = podcasts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2D),
      appBar: AppBar(
        title: Text("Favorites", style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64.sp, color: Colors.white24),
            SizedBox(height: 16.h),
            Text(
              "No favorites yet",
              style: TextStyle(color: Colors.white54, fontSize: 16.sp),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final podcast = _favorites[index];
          return GestureDetector(
            onTap: () {
              context.push('/podcast-details', extra: podcast);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF262033),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      podcast.imageUrl,
                      width: 70.w,
                      height: 70.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 70.w,
                        height: 70.w,
                        color: Colors.grey,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          podcast.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          podcast.author,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(Icons.arrow_forward_ios,
                      color: Colors.white30, size: 16.sp),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}