import 'package:flutter/material.dart';
import 'package:movies_app/features/movie/presentation/providers/movie_provider.dart';
import 'package:movies_app/features/search/presentation/pages/search_page.dart'; // Ensure this import exists
import 'package:provider/provider.dart';

import '../widgets/movies_grid.dart';
import '../../../../core/widgets/app_error_widget.dart'; // Import for AppErrorWidget
import '../../../../core/widgets/app_loading_widget.dart'; // Import for AppLoadingWidget

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch upcoming movies after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchUpcomingMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          // Show loading indicator when data is being fetched and movie list is empty
          if (provider.isLoading && provider.movies.isEmpty) {
            return const AppLoadingWidget(message: 'Loading upcoming movies...');
          }
          // Show error widget if an error occurred
          else if (provider.error != null) {
            return AppErrorWidget(
              errorMessage: provider.error!,
              onRetry: () => provider.fetchUpcomingMovies(), // Retry fetching on button press
            );
          }
          // Show movies grid if data is available
          else if (provider.movies.isNotEmpty) {
            return MoviesGrid(movies: provider.movies);
          }
          // Fallback for no data and no error (e.g., initial state before loading)
          return const Center(child: Text('No upcoming movies available.'));
        },
      ),
    );
  }
}


