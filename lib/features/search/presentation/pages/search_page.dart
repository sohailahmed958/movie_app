import 'package:cached_network_image/cached_network_image.dart'; // Already imported
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../movie/presentation/pages/movie_detail_page.dart';
import '../providers/search_provider.dart';
import '../../../../core/widgets/app_loading_widget.dart'; // Import for loading
import '../../../../core/widgets/app_error_widget.dart'; // Import for error

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search), // Add a search icon
          ),
          onChanged: (query) {
            // Trigger search every time the query changes
            context.read<SearchProvider>().search(query);
          },
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          // Show loading indicator
          if (provider.isSearching && provider.searchResults.isEmpty) {
            return const AppLoadingWidget(message: 'Searching...');
          }
          // Show error message
          else if (provider.searchError != null) {
            return AppErrorWidget(
              errorMessage: provider.searchError!,
              onRetry: () => provider.search(_searchController.text), // Retry with current query
            );
          }
          // Show initial message or no results found
          else if (_searchController.text.isEmpty) {
            return const Center(child: Text('Start typing to search for movies.'));
          } else if (provider.searchResults.isEmpty && !provider.isSearching) {
            return const Center(child: Text('No movies found for your search.'));
          }
          // Display search results in a ListView
          return ListView.builder(
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final movie = provider.searchResults[index];
              return ListTile(
                leading: SizedBox(
                  width: 50,
                  height: 75,
                  child: CachedNetworkImage( // Use CachedNetworkImage
                    imageUrl: 'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                title: Text(movie.title),
                subtitle: Text(movie.releaseDate),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

