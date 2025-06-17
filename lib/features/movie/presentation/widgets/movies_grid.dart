import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/app_constants.dart';
import 'package:movies_app/core/widgets/cached_image.dart'; // Import CachedImage
import '../../data/models/movie_model.dart';
import '../pages/movie_detail_page.dart';

class MoviesGrid extends StatelessWidget {
  final List<Movie> movies;

  const MoviesGrid({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding), // Use constant for padding
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns
        childAspectRatio: 0.7, // Aspect ratio for each movie card
        crossAxisSpacing: AppConstants.defaultPadding, // Spacing between columns
        mainAxisSpacing: AppConstants.defaultPadding, // Spacing between rows
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            // Navigate to movie detail page on tap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailPage(movie: movie),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius), // Use constant for rounded corners
                  child: CachedImage( // Use the CachedImage widget for efficient image loading
                    imageUrl: '${AppConstants.tmdbImageBaseUrl}/${AppConstants.imageSizeW500}${movie.posterPath}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // CachedImage handles placeholder and error widgets internally
                    // You can customize them if needed, e.g., placeholder: const Icon(Icons.movie)
                  ),
                ),
              ),
              const SizedBox(height: 8), // Spacing between image and text
              Text(
                movie.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold), // Use theme for text style
                maxLines: 2, // Limit title to 2 lines
                overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
              ),
            ],
          ),
        );
      },
    );
  }
}

