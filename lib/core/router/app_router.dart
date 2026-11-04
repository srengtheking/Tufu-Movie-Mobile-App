import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tufu_movie/features/auth/screens/login_screen.dart';
import 'package:tufu_movie/features/auth/screens/register_screen.dart';
import 'package:tufu_movie/features/home/home_screen.dart';
import 'package:tufu_movie/features/movie_detail/movie_detail_screen.dart';
import 'package:tufu_movie/features/movies/movies_screen.dart';
import 'package:tufu_movie/features/player/screens/player_screen.dart';
import 'package:tufu_movie/features/profile/profile_screen.dart';
import 'package:tufu_movie/features/search/search_screen.dart';
import 'package:tufu_movie/shared/widgets/app_bottom_navigation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppBottomNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/register',
                builder: (context, state) => const RegisterScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/movies',
                builder: (context, state) => const MoviesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/watch/:episodeId',
                builder: (context, state) {
                  return PlayerScreen(
                    episodeId: state.pathParameters['episodeId']!,
                    title: state.uri.queryParameters['title'] ?? 'Movie',
                    videoUrl: state.uri.queryParameters['url'] ?? '',
                  );
                },
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/movie/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MovieDetailScreen(movieId: id);
        },
      ),
    ],
  );
}
