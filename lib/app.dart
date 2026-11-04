import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';

class TufuMovieApp extends StatefulWidget {
  final AuthProvider auth;

  const TufuMovieApp({super.key, required this.auth});

  @override
  State<TufuMovieApp> createState() => _TufuMovieAppState();
}

class _TufuMovieAppState extends State<TufuMovieApp> {
  late final GoRouter _router = AppRouter.create(widget.auth);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tufu Movie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
