import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'features/discover/cubit/discover_cubit.dart';
import 'features/favorites/cubit/favorite_cubit.dart';
import 'features/now_playing/cubit/now_playing_cubit.dart';
import 'shared/repositories/podcast/podcast_api_repository.dart';
import 'shared/repositories/podcast/podcast_repository.dart';
import 'podkes_app.dart';

class MyApp extends StatelessWidget {
  final String? initialToken;

  const MyApp({super.key, this.initialToken});

  @override
  Widget build(BuildContext context) {
    final podcastRepository = _createPodcastRepository(initialToken);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PodcastRepository>.value(value: podcastRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => DiscoverCubit(podcastRepository)..loadPodcasts()),
          BlocProvider(create: (_) => NowPlayingCubit()),
          BlocProvider(create: (_) => FavoriteCubit(podcastRepository)..loadFavorites()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, __) => const PodkesApp(),
        ),
      ),
    );
  }

  PodcastRepository _createPodcastRepository(String? token) {
    final apiClient = ApiClient(baseUrl: AppConfig.instance.baseUrl);

    if (token != null) {
      apiClient.setToken(token);
    }

    return PodcastApiRepository(apiClient);
  }
}