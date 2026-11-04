import 'movie.dart';

/// Placeholder catalogue until the movies API is wired up.
class SampleMovies {
  SampleMovies._();

  static const _sampleVideo =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

  static const genres = ['Action', 'Sci-Fi', 'Drama', 'Comedy', 'Thriller'];

  static const all = <Movie>[
    Movie(
      id: '1',
      title: 'The Dark Knight',
      year: '2008',
      rating: '9.0',
      duration: '2h 32m',
      genre: 'Action',
      description:
          'When the menace known as the Joker wreaks havoc on Gotham, Batman '
          'must accept one of the greatest tests of his ability to fight injustice.',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
      backdropUrl:
          'https://image.tmdb.org/t/p/w780/nMKdUUepR0i5zn0y1T4CsSB5chy.jpg',
      videoUrl: _sampleVideo,
      price: 120,
    ),
    Movie(
      id: '2',
      title: 'Inception',
      year: '2010',
      rating: '8.8',
      duration: '2h 28m',
      genre: 'Sci-Fi',
      description:
          'A thief who steals corporate secrets through dream-sharing technology '
          'is given the inverse task of planting an idea into a mind.',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg',
      backdropUrl:
          'https://image.tmdb.org/t/p/w780/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg',
      videoUrl: _sampleVideo,
    ),
    Movie(
      id: '3',
      title: 'Interstellar',
      year: '2014',
      rating: '8.7',
      duration: '2h 49m',
      genre: 'Sci-Fi',
      description:
          'A team of explorers travel through a wormhole in space in an attempt '
          'to ensure humanity\'s survival.',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
      backdropUrl:
          'https://image.tmdb.org/t/p/w780/8b8R8l88Qje9dn9OE8PY05Nxl1X.jpg',
      videoUrl: _sampleVideo,
      price: 80,
    ),
    Movie(
      id: '4',
      title: 'Joker',
      year: '2019',
      rating: '8.4',
      duration: '2h 2m',
      genre: 'Drama',
      description:
          'A mentally troubled comedian embarks on a downward spiral that leads '
          'to the creation of an iconic villain.',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
      backdropUrl:
          'https://image.tmdb.org/t/p/w780/n6bUvigpRFqSwmPp1m2YADdbRBc.jpg',
      videoUrl: _sampleVideo,
      price: 60,
    ),
    Movie(
      id: '5',
      title: 'Parasite',
      year: '2019',
      rating: '8.5',
      duration: '2h 12m',
      genre: 'Thriller',
      description:
          'Greed and class discrimination threaten the newly formed symbiotic '
          'relationship between the wealthy Park family and the destitute Kim clan.',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
      backdropUrl:
          'https://image.tmdb.org/t/p/w780/TU9NIjwzjoKPwQHoHshkFcQUCG.jpg',
      videoUrl: _sampleVideo,
    ),
    Movie(
      id: '6',
      title: 'Dune',
      year: '2021',
      rating: '8.0',
      duration: '2h 35m',
      genre: 'Sci-Fi',
      description:
          'Paul Atreides leads nomadic tribes in a battle to control the desert '
          'planet Arrakis.',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg',
      backdropUrl:
          'https://image.tmdb.org/t/p/w780/jYEW5xZkZk2WTrdbMGAPFuBqbDc.jpg',
      videoUrl: _sampleVideo,
      price: 150,
    ),
  ];

  static Movie byId(String id) =>
      all.firstWhere((m) => m.id == id, orElse: () => all.first);

  static List<Movie> get trending => all.take(4).toList();
  static List<Movie> get newReleases => all.reversed.toList();
  static Movie get featured => all[2];

  static List<Movie> moreLike(Movie movie) =>
      all.where((m) => m.id != movie.id).toList();
}
