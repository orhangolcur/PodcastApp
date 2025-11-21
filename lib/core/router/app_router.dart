import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:podkes_app/features/login/view/login_screen.dart';
import '../../features/discover/view/discover_screen.dart';
import '../../features/favorites/view/favorites_screen.dart';
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
      ],
    ),
    GoRoute(
      path: '/now-playing',
      name: 'nowPlaying',
      builder: (context, state) {
        final nowPlayingCubit = context.read<NowPlayingCubit>();
        final currentPodcast = nowPlayingCubit.current;

        if (currentPodcast == null) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'Henüz bir podcast seçilmedi',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        return NowPlayingScreen(podcast: currentPodcast);
      },
    ),
  ],
);
