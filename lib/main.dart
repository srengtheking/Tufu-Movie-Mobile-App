import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tufu_movie/features/player/providers/player_provider.dart';

import 'app.dart';
import 'features/auth/providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: const TufuMovieApp(),
    ),
  );
}
