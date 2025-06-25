import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/core/constants/app_constants.dart';
import 'package:movies_app/core/widgets/app_loading_widget.dart';
import 'package:movies_app/core/widgets/app_error_widget.dart';
import 'package:movies_app/core/utils/date_utils.dart';

import '../../../ticket/presentation/pages/ticket_booking_page.dart';
import '../../data/models/movie_details.dart';
import '../../data/models/movie_model.dart';
import '../providers/movie_provider.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchMovieDetails(widget.movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading || provider.selectedMovie == null) {
            return const AppLoadingWidget(message: 'Loading movie details...');
          } else if (provider.error != null) {
            return AppErrorWidget(
              errorMessage: provider.error!,
              onRetry: () => provider.fetchMovieDetails(widget.movie.id),
            );
          }

          final MovieDetails movieDetails = provider.selectedMovie!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios_new, color: whiteColor),
                ),
                title: Text(
                  'Watch',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: whiteColor),
                ),
                expandedHeight: 370.h,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl:
                              '${AppConstants.tmdbImageBaseUrl}/${AppConstants.imageSizeOriginal}${movieDetails.backdropPath}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder:
                              (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          errorWidget:
                              (context, url, error) => const Icon(
                                Icons.broken_image,
                                size: 60,
                                color: Colors.grey,
                              ),
                        ),
                      ),

                      Positioned(
                        bottom: 20.h,
                        left: AppConstants.defaultPadding.w,
                        right: AppConstants.defaultPadding.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              movieDetails.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: yellowColor),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'In Theaters ${AppDateUtils.formatDate(DateTime.parse(movieDetails.releaseDate), format: 'MMMM dd, yyyy')}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: whiteColor),
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              width: 200.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => TicketBookingPage(
                                            movie: widget.movie,
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: skyBlueColor,
                                  foregroundColor: whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),

                                child: Text(
                                  'Get Tickets',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppConstants.defaultPadding.w),
                            SizedBox(
                              width: 200.w,
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.play_arrow,
                                  size: 20.w,
                                  color: whiteColor,
                                ),
                                label: Text(
                                  'Watch Trailer',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  side: BorderSide(color: skyBlueColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.defaultPadding.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      // Genres
                      Text(
                        'Genres',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        children:
                            movieDetails.genres
                                .map(
                                  (genre) => Chip(
                                    label: Text(
                                      genre.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        fontSize: 12,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    backgroundColor:
                                        colorList[genre.id % colorList.length],
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      SizedBox(height: AppConstants.defaultPadding.h),
                      // Overview
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        movieDetails.overview,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: greyColor,
                        ),
                      ),
                      SizedBox(height: AppConstants.defaultPadding.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
