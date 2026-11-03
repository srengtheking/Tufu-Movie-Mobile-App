
tufu_movie/
│
├── android/
├── ios/
├── web/
├── assets/
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   └── animations/
│
├── lib/
│   │
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── api_constants.dart
│   │   │   └── asset_constants.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_text_styles.dart
│   │   │
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   ├── api_interceptor.dart
│   │   │   └── api_exception.dart
│   │   │
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   │
│   │   ├── storage/
│   │   │   └── secure_storage.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── date_utils.dart
│   │   │   └── validators.dart
│   │   │
│   │   └── widgets/
│   │       ├── app_loading.dart
│   │       ├── app_error.dart
│   │       └── app_button.dart
│   │
│   ├── features/
│   │   │
│   │   ├── home/
│   │   │   ├── data/
│   │   │   │   └── home_repository.dart
│   │   │   ├── models/
│   │   │   │   └── home_model.dart
│   │   │   ├── providers/
│   │   │   │   └── home_provider.dart
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── featured_banner.dart
│   │   │       ├── trending_movies.dart
│   │   │       ├── latest_movies.dart
│   │   │       └── movie_section.dart
│   │   │
│   │   ├── movies/
│   │   │   ├── data/
│   │   │   │   └── movie_repository.dart
│   │   │   ├── models/
│   │   │   │   └── movie_model.dart
│   │   │   ├── providers/
│   │   │   │   └── movie_provider.dart
│   │   │   ├── screens/
│   │   │   │   ├── movies_screen.dart
│   │   │   │   └── movie_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── movie_card.dart
│   │   │       ├── movie_grid.dart
│   │   │       └── movie_info.dart
│   │   │
│   │   ├── episodes/
│   │   │   ├── data/
│   │   │   │   └── episode_repository.dart
│   │   │   ├── models/
│   │   │   │   └── episode_model.dart
│   │   │   ├── providers/
│   │   │   │   └── episode_provider.dart
│   │   │   ├── screens/
│   │   │   │   └── episode_screen.dart
│   │   │   └── widgets/
│   │   │       └── episode_list.dart
│   │   │
│   │   ├── player/
│   │   │   ├── providers/
│   │   │   │   └── player_provider.dart
│   │   │   ├── screens/
│   │   │   │   └── player_screen.dart
│   │   │   └── widgets/
│   │   │       ├── video_player.dart
│   │   │       ├── player_controls.dart
│   │   │       └── next_episode.dart
│   │   │
│   │   ├── search/
│   │   │   ├── data/
│   │   │   │   └── search_repository.dart
│   │   │   ├── providers/
│   │   │   │   └── search_provider.dart
│   │   │   └── screens/
│   │   │       └── search_screen.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   └── auth_repository.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── providers/
│   │   │   │   └── auth_provider.dart
│   │   │   └── screens/
│   │   │       ├── login_screen.dart
│   │   │       └── register_screen.dart
│   │   │
│   │   ├── profile/
│   │   │   ├── data/
│   │   │   │   └── profile_repository.dart
│   │   │   └── screens/
│   │   │       └── profile_screen.dart
│   │   │
│   │   ├── watchlist/
│   │   │   ├── data/
│   │   │   │   └── watchlist_repository.dart
│   │   │   └── screens/
│   │   │       └── watchlist_screen.dart
│   │   │
│   │   └── history/
│   │       ├── data/
│   │       │   └── history_repository.dart
│   │       └── screens/
│   │           └── history_screen.dart
│   │
│   └── shared/
│       ├── models/
│       ├── widgets/
│       └── extensions/
│
├── test/
├── pubspec.yaml
└── README.md