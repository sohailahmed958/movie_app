import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_constants.dart';
import 'package:movies_app/core/widgets/cached_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/movie_model.dart';
import '../pages/movie_detail_page.dart';

class MoviesGrid extends StatelessWidget {
  final List<Movie> movies;

  const MoviesGrid({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding.w,
        vertical: AppConstants.defaultPadding.h,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailPage(movie: movie),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: ClipRRect( // Clip the Stack's content to the rounded corners
              borderRadius: BorderRadius.circular(8.r),
              child: Stack(
                children: [
                  CachedImage(
                    imageUrl: movie.posterPath != null && movie.posterPath!.isNotEmpty
                        ? '${AppConstants.tmdbImageBaseUrl}/${AppConstants.imageSizeW500}${movie.posterPath}'
                        : '',
                    height: 100.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius: 0,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(left:8.w,bottom: 8.h),
                      decoration: BoxDecoration(
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            movie.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16,color: whiteColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
