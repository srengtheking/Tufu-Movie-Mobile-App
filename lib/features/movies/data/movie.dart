class Movie {
  final String id;
  final String title;
  final String year;
  final String rating;
  final String duration;
  final String genre;
  final String description;
  final String posterUrl;
  final String backdropUrl;
  final String videoUrl;

  /// Price in Tufu coins. 0 means free to watch.
  final int price;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.duration,
    required this.genre,
    required this.description,
    required this.posterUrl,
    required this.backdropUrl,
    required this.videoUrl,
    this.price = 0,
  });

  bool get isFree => price == 0;
}
