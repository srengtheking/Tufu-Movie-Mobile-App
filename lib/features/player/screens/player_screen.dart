import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_buttons.dart';
import '../../movies/data/sample_movies.dart';
import '../widgets/video_player_widget.dart';

class PlayerScreen extends StatelessWidget {
  final String movieId;

  const PlayerScreen({super.key, required this.movieId});

  void _soon(BuildContext context, String what) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$what is coming soon.')));
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final movie = SampleMovies.byId(movieId);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppBackButton(),
              ),
            ),
            VideoPlayerWidget(videoUrl: movie.videoUrl),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.description,
                    style: TextStyle(
                      color: p.textSecondary,
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      for (final (i, label) in const [
                        'My List',
                        'Download',
                        'Share',
                      ].indexed) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(
                          child: SecondaryButton(
                            label: label,
                            height: 46,
                            fontSize: 14,
                            background: p.card,
                            onPressed: () => _soon(context, label),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
