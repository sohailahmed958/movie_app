// lib/core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'Movie App';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

  // Image sizes
  static const String imageSizeW92 = 'w92';
  static const String imageSizeW154 = 'w154';
  static const String imageSizeW185 = 'w185';
  static const String imageSizeW342 = 'w342';
  static const String imageSizeW500 = 'w500';
  static const String imageSizeW780 = 'w780';
  static const String imageSizeOriginal = 'original';

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashAnimationDuration = Duration(milliseconds: 1500);

  // Default padding
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;

  static const int connectTimeoutInSeconds = 30;
  static const int receiveTimeoutInSeconds = 30;
}




/*
class AppConstants {
  static const String appName = 'Movie App';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

  // Image sizes
  static const String imageSizeW92 = 'w92';
  static const String imageSizeW154 = 'w154';
  static const String imageSizeW185 = 'w185';
  static const String imageSizeW342 = 'w342';
  static const String imageSizeW500 = 'w500';
  static const String imageSizeW780 = 'w780';
  static const String imageSizeOriginal = 'original';

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashAnimationDuration = Duration(milliseconds: 1500);

  // Default padding
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;

  // API timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
*/