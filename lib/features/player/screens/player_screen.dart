import 'package:flutter/material.dart';

import '../widgets/video_player_widget.dart';
import '../../../core/theme/app_colors.dart';

class PlayerScreen extends StatelessWidget {
  final String episodeId;
  final String title;
  final String videoUrl;

  const PlayerScreen({
    super.key,
    required this.episodeId,
    required this.title,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        children: [
          VideoPlayerWidget(videoUrl: videoUrl),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Episode ID: $episodeId',
                  style: const TextStyle(color: AppColors.grey),
                ),

                const SizedBox(height: 25),

                const Text(
                  'More Episodes',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                ...List.generate(
                  5,
                  (index) => ListTile(
                    leading: const Icon(Icons.play_circle_outline),
                    title: Text('Episode ${index + 1}'),
                    subtitle: const Text('Watch episode'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
