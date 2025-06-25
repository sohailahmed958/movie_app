import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../movie/presentation/pages/movie_detail_page.dart';
import '../../../movie/presentation/providers/movie_provider.dart';
import '../../../movie/presentation/widgets/movies_grid.dart';
import '../providers/search_provider.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/constants/app_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().setSearched(false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: lightGreyColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 24.w),
          color: Theme.of(context).iconTheme.color,
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        centerTitle: true,
        title: Consumer<SearchProvider>(
          builder: (context, srchVM, child) {
            return srchVM.hasSearched
                ? Text(
                  '${srchVM.searchResults.length} Results Found',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
                : Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: TextFormField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'TV shows, movies and more',
                      filled: true,
                      fillColor: lightGreyColor,
                      hintStyle: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: greyColor),

                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20.w,
                        color: blackColor,
                      ),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 20.w,
                                  color: blackColor,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<SearchProvider>().search('');
                                },
                              )
                              : null,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                    onChanged: (query) {
                      context.read<SearchProvider>().search(query);
                    },

                    onFieldSubmitted: (query) {
                      srchVM.setSearched(true);
                    },
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: blackColor),
                  ),
                );
          },
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          if (_searchController.text.isEmpty) {
            return MoviesGrid(movies: movieProvider.movies);
          } else {
            if (provider.isSearching && provider.searchResults.isEmpty) {
              return const AppLoadingWidget(message: 'Searching...');
            } else if (provider.searchError != null) {
              return AppErrorWidget(
                errorMessage: provider.searchError!,
                onRetry: () => provider.search(_searchController.text),
              );
            } else if (provider.searchResults.isEmpty &&
                !provider.isSearching) {
              return const Center(
                child: Text('No movies found for your search.'),
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!provider.hasSearched) ...[
                    SizedBox(height: 8.h),
                    Text(
                      'Top Results',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: blackColor,
                      ),
                    ),
                    Divider(),
                  ],

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: AppConstants.defaultPadding.h,
                      ),
                      itemCount: provider.searchResults.length,
                      itemBuilder: (context, index) {
                        final movie = provider.searchResults[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: AppConstants.defaultPadding.h,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailPage(movie: movie),
                                ),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        movie.posterPath != null &&
                                                movie.posterPath!.isNotEmpty
                                            ? '${AppConstants.tmdbImageBaseUrl}/${AppConstants.imageSizeW185}${movie.posterPath}'
                                            : '',
                                    width: 130.w,
                                    height: 80.h,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Icon(
                                          Icons.broken_image,
                                          size: 40.w,
                                          color: Colors.grey,
                                        ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        movie.title,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        movie.originalTitle,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                          fontSize: 12.sp,
                                          color: midGreyColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: skyBlueColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
