import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerProvider extends ChangeNotifier {
  VideoPlayerController? _controller;

  bool _isLoading = false;
  String? _errorMessage;

  VideoPlayerController? get controller => _controller;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isInitialized =>
      _controller != null && _controller!.value.isInitialized;

  bool get isPlaying => isInitialized && _controller!.value.isPlaying;

  Duration get position =>
      isInitialized ? _controller!.value.position : Duration.zero;

  Duration get duration =>
      isInitialized ? _controller!.value.duration : Duration.zero;

  Future<void> initialize(String videoUrl) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await disposeController();

    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      await _controller!.initialize();
      await _controller!.setLooping(false);

      _controller!.addListener(_onPlayerChanged);
    } catch (e) {
      _errorMessage = 'Unable to load video: $e';
      await disposeController();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onPlayerChanged() {
    notifyListeners();
  }

  Future<void> play() async {
    if (!isInitialized) return;
    await _controller!.play();
  }

  Future<void> pause() async {
    if (!isInitialized) return;
    await _controller!.pause();
  }

  Future<void> togglePlayPause() async {
    if (!isInitialized) return;

    if (_controller!.value.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seek(Duration position) async {
    if (!isInitialized) return;
    await _controller!.seekTo(position);
  }

  Future<void> forward({int seconds = 10}) async {
    if (!isInitialized) return;

    final newPosition =
        _controller!.value.position + Duration(seconds: seconds);

    final maxDuration = _controller!.value.duration;

    await seek(newPosition > maxDuration ? maxDuration : newPosition);
  }

  Future<void> backward({int seconds = 10}) async {
    if (!isInitialized) return;

    final newPosition =
        _controller!.value.position - Duration(seconds: seconds);

    await seek(newPosition.isNegative ? Duration.zero : newPosition);
  }

  Future<void> disposeController() async {
    final oldController = _controller;
    _controller = null;

    if (oldController != null) {
      oldController.removeListener(_onPlayerChanged);
      await oldController.dispose();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onPlayerChanged);
    _controller?.dispose();
    _controller = null;

    super.dispose();
  }
}
