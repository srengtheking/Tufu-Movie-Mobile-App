import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/theme/app_colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final VideoPlayerController controller =
      VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

  bool isInitialized = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() => isInitialized = true);
      await controller.play();
    } catch (_) {
      if (!mounted) return;
      setState(() => errorMessage = 'Unable to load video.');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  static String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
  }

  void _seekBy(int seconds) {
    final v = controller.value;
    var target = v.position + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (target > v.duration) target = v.duration;
    controller.seekTo(target);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return ColoredBox(
      color: p.surface,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: isInitialized ? controller.value.aspectRatio : 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (isInitialized) VideoPlayer(controller),
                if (errorMessage != null)
                  Center(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: p.textSecondary),
                    ),
                  )
                else if (!isInitialized)
                  const Center(child: CircularProgressIndicator())
                else
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: controller,
                    builder: (context, value, _) => ColoredBox(
                      color: Colors.black26,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: 'Back 10 seconds',
                            onPressed: () => _seekBy(-10),
                            icon: const Icon(
                              Icons.replay_10_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                          const SizedBox(width: 28),
                          Material(
                            color: AppColors.primary,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: value.isPlaying
                                  ? controller.pause
                                  : controller.play,
                              child: SizedBox(
                                width: 64,
                                height: 64,
                                child: Icon(
                                  value.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 36,
                                  semanticLabel: value.isPlaying
                                      ? 'Pause'
                                      : 'Play',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 28),
                          IconButton(
                            tooltip: 'Forward 10 seconds',
                            onPressed: () => _seekBy(10),
                            icon: const Icon(
                              Icons.forward_10_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final timeStyle = TextStyle(
                  color: p.textSecondary,
                  fontSize: 12,
                  fontFeatures: const [FontFeature.tabularFigures()],
                );
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: SizedBox(
                        height: 5,
                        child: isInitialized
                            ? VideoProgressIndicator(
                                controller,
                                allowScrubbing: true,
                                padding: EdgeInsets.zero,
                                colors: VideoProgressColors(
                                  playedColor: AppColors.brand,
                                  bufferedColor: p.textMuted.withValues(
                                    alpha: 0.5,
                                  ),
                                  backgroundColor: p.button,
                                ),
                              )
                            : ColoredBox(color: p.button),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_format(value.position), style: timeStyle),
                        Text(_format(value.duration), style: timeStyle),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
