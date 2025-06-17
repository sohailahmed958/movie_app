import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/app_constants.dart';
import 'package:movies_app/core/widgets/cached_image.dart';

import '../../features/movie/data/models/movie_model.dart'; // Make sure this path is correct

class OptimizedMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const OptimizedMovieCard({
    Key? key,
    required this.movie,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedImage(
                imageUrl: '${AppConstants.tmdbImageBaseUrl}/${AppConstants.imageSizeW500}${movie.posterPath}',
                borderRadius: AppConstants.defaultBorderRadius,
                fit: BoxFit.cover, // Ensure image covers the space
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall, // Use theme text style
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${movie.voteAverage.toStringAsFixed(1)}/10'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/app_constants.dart';
import 'package:movies_app/core/widgets/cached_image.dart';

import '../../features/movie/data/models/movie_model.dart';

class OptimizedMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const OptimizedMovieCard({
    Key? key,
    required this.movie,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedImage(
                imageUrl: '${AppConstants.tmdbImageBaseUrl}/${AppConstants.imageSizeW500}${movie.posterPath}',
                borderRadius: AppConstants.defaultBorderRadius,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${movie.voteAverage.toStringAsFixed(1)}/10'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/