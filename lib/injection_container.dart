import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'features/movie/data/datasources/movie_local_data_source.dart';
import 'features/movie/data/datasources/movie_remote_data_source.dart';
import 'features/movie/data/repositories/movie_repository_impl.dart';
import 'features/movie/domain/repositories/movie_repository.dart';
import 'features/movie/domain/usecases/get_movie_details.dart';
import 'features/movie/domain/usecases/get_upcomingMovies.dart';
import 'features/movie/presentation/providers/movie_provider.dart';
import 'features/search/data/datasources/search_remote_data_source.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/search_movies.dart';
import 'features/search/presentation/providers/search_provider.dart';
import 'features/ticket/presentation/providers/ticket_booking_provider.dart';
import 'core/theme/theme_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.instance,
  );

  sl.registerLazySingleton<DioClient>(
    () => DioClient(dio: sl(), baseUrl: AppConstants.tmdbBaseUrl),
  );
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));


  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dioClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetUpcomingMovies>(() => GetUpcomingMovies(sl()));
  sl.registerLazySingleton<GetMovieDetails>(() => GetMovieDetails(sl()));

  // Providers
  sl.registerFactory<MovieProvider>(
    () => MovieProvider(getUpcomingMovies: sl(), getMovieDetails: sl()),
  );

  // Feature: Search
  // Data Sources
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dioClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use Cases
  sl.registerLazySingleton<SearchMovies>(() => SearchMovies(sl()));

  // Providers
  sl.registerFactory<SearchProvider>(() => SearchProvider(searchMovies: sl()));

  // Feature: Ticket Booking (and Theme)
  // Providers
  sl.registerFactory<TicketProvider>(() => TicketProvider());
  sl.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
}
