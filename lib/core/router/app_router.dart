import 'package:go_router/go_router.dart';
import 'package:tufu_movie/features/auth/providers/auth_provider.dart';
import 'package:tufu_movie/features/auth/screens/login_screen.dart';
import 'package:tufu_movie/features/auth/screens/register_screen.dart';
import 'package:tufu_movie/features/downloads/downloads_screen.dart';
import 'package:tufu_movie/features/home/home_screen.dart';
import 'package:tufu_movie/features/movie_detail/movie_detail_screen.dart';
import 'package:tufu_movie/features/movies/movies_screen.dart';
import 'package:tufu_movie/features/player/screens/player_screen.dart';
import 'package:tufu_movie/features/profile/profile_screen.dart';
import 'package:tufu_movie/features/search/search_screen.dart';
import 'package:tufu_movie/features/splash/splash_screen.dart';
import 'package:tufu_movie/features/wallet/screens/buy_movie_screen.dart';
import 'package:tufu_movie/features/wallet/screens/not_enough_coins_screen.dart';
import 'package:tufu_movie/features/wallet/screens/payment_screen.dart';
import 'package:tufu_movie/features/wallet/screens/purchase_success_screen.dart';
import 'package:tufu_movie/features/wallet/screens/wallet_screen.dart';
import 'package:tufu_movie/widgets/app_bottom_navigation.dart';

class AppRouter {
  AppRouter._();

  static const _authRoutes = {'/login', '/register'};

  static GoRouter create(AuthProvider auth) => GoRouter(
    initialLocation: '/splash',
    refreshListenable: auth,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (location == '/splash') return null;
      if (auth.status == AuthStatus.unknown) return '/splash';

      final onAuthRoute = _authRoutes.contains(location);
      if (!auth.isAuthenticated && !onAuthRoute) return '/login';
      if (auth.isAuthenticated && onAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppBottomNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/', builder: (_, _) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/downloads',
                builder: (_, _) => const DownloadsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (_, state) =>
            LoginScreen(initialEmail: state.uri.queryParameters['email']),
      ),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(path: '/movies', builder: (_, _) => const MoviesScreen()),
      GoRoute(
        path: '/movie/:id',
        builder: (_, state) =>
            MovieDetailScreen(movieId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/watch/:id',
        builder: (_, state) =>
            PlayerScreen(movieId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/buy/:id',
        builder: (_, state) =>
            BuyMovieScreen(movieId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/not-enough-coins/:id',
        builder: (_, state) =>
            NotEnoughCoinsScreen(movieId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/purchase-success/:id',
        builder: (_, state) =>
            PurchaseSuccessScreen(movieId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/wallet', builder: (_, _) => const WalletScreen()),
      GoRoute(
        path: '/payment/:packId',
        builder: (_, state) =>
            PaymentScreen(packId: state.pathParameters['packId']!),
      ),
    ],
  );
}
