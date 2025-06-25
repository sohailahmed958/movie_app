import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/features/movie/presentation/providers/movie_provider.dart';
import 'package:movies_app/features/search/presentation/pages/search_page.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../data/models/movie_model.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/constants/app_constants.dart';
import 'movie_detail_page.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchUpcomingMovies();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
    } else {
      String tabName;
      switch (index) {
        case 0:
          tabName = 'Dashboard';
          break;
        case 2:
          tabName = 'Media Library';
          break;
        case 3:
          tabName = 'More';
          break;
        default:
          tabName = 'Unknown Tab';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$tabName tab will be coming soon!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: AppConstants.defaultPadding.w),
          child: Text('Watch', style: Theme.of(context).textTheme.bodyMedium),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 24.w),
            color: Theme.of(context).iconTheme.color,
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
          ),
          SizedBox(width: AppConstants.defaultPadding.w),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.movies.isEmpty) {
            return const AppLoadingWidget(
              message: 'Loading upcoming movies...',
            );
          } else if (provider.error != null) {
            return AppErrorWidget(
              errorMessage: provider.error!,
              onRetry: () => provider.fetchUpcomingMovies(),
            );
          } else if (provider.movies.isNotEmpty) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding.w,
                vertical: AppConstants.defaultPadding.h,
              ),
              itemCount: provider.movies.length,
              itemBuilder: (context, index) {
                final movie = provider.movies[index];
                return _buildMovieListItem(context, movie);
              },
            );
          }
          return const Center(child: Text('No upcoming movies available.'));
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: blackColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(
            context,
            'assets/icons/dashboard.png',
            'Dashboard',
            0,
          ),
          _buildNavBarItem(context, 'assets/icons/watch.png', 'Watch', 1),
          _buildNavBarItem(
            context,
            "assets/icons/media.png",
            'Media Library',
            2,
          ),
          _buildNavBarItem(context, 'assets/icons/more.png', 'More', 3),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
    BuildContext context,
    String iconPath,
    String label,
    int index,
  ) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, color: isSelected ? Colors.white : greyColor),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? Colors.white : greyColor,
            ),
          ),
        ],
      ),
    );
  }

  //  movie list item
  Widget _buildMovieListItem(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppConstants.defaultPadding.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Stack(
            children: [
              CachedImage(
                imageUrl:
                    movie.posterPath != null && movie.posterPath!.isNotEmpty
                        ? '${AppConstants.tmdbImageBaseUrl}/${AppConstants.imageSizeW500}${movie.posterPath}'
                        : '',
                height: 170.h,
                width: double.infinity,
                fit: BoxFit.cover,
                borderRadius: 0,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(AppConstants.defaultPadding.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        blackColor.withOpacity(0.7),
                        blackColor.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: whiteColor),
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
  }
}
