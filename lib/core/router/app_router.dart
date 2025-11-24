import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:podkes_app/features/login/view/login_screen.dart';
import 'package:podkes_app/shared/entities/podcast_entitiy.dart';
import '../../features/discover/view/discover_screen.dart';
import '../../features/favorites/view/favorites_screen.dart';
import '../../features/now_playing/cubit/now_playing_state.dart';
import '../../features/podcast_details/view/podcast_detail_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../../features/onboarding/view/onboarding_screen.dart';
import '../../features/now_playing/cubit/now_playing_cubit.dart';
import '../../features/now_playing/view/now_playing_screen.dart';
import '../widgets/custom_nav_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => CustomNavShell(child: child),
      routes: [
        GoRoute(
          path: '/discover',
          name: 'discover',
          builder: (context, state) => const DiscoverScreen(),
        ),
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/podcast-details',
          name: 'podcastDetails',
          builder: (context, state) {
            final podcast = state.extra as PodcastEntity;
            return PodcastDetailScreen(podcast: podcast);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/now-playing',
      name: 'nowPlaying',
      builder: (context, state) {
        final nowPlayingState = context.read<NowPlayingCubit>().state;

        if (nowPlayingState is NowPlayingLoaded) {
          final currentPodcast = nowPlayingState.podcast;
          return NowPlayingScreen(podcast: currentPodcast);
        }

        return const Scaffold(
          backgroundColor: Color(0xFF1C1B2D),
          body: Center(
            child: Text(
              'Henüz bir podcast seçilmedi',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        );
      },
    ),
  ],
);
