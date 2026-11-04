class VideoModel {
  final String id;
  final String title;
  final String videoUrl;
  final String? thumbnailUrl;
  final String? nextEpisodeId;

  const VideoModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    this.thumbnailUrl,
    this.nextEpisodeId,
  });
}
