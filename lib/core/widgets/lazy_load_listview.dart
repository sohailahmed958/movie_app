import 'package:flutter/material.dart';
import 'package:movies_app/core/widgets/app_loading_widget.dart';

class LazyLoadListView extends StatefulWidget {
  final Future<void> Function() onLoadMore;
  final Widget child; // The content that will be lazy loaded
  final bool isLoadingMore; // To indicate if more data is being loaded

  const LazyLoadListView({
    Key? key,
    required this.onLoadMore,
    required this.child,
    this.isLoadingMore = false, // Default to false
  }) : super(key: key);

  @override
  _LazyLoadListViewState createState() => _LazyLoadListViewState();
}

class _LazyLoadListViewState extends State<LazyLoadListView> {
  final ScrollController _scrollController = ScrollController();
  // bool _isLoading = false; // Removed as it's now passed via widget.isLoadingMore

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Check if user has scrolled to the end and not currently loading more
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9 && // Trigger slightly before end
        !widget.isLoadingMore) { // Use widget's isLoadingMore property
      widget.onLoadMore(); // Call the load more function
    }
  }

  // _loadMore logic is now handled externally by the parent widget calling onLoadMore and setting isLoadingMore
  // Future<void> _loadMore() async {
  //   if (_isLoading) return;
  //   setState(() => _isLoading = true);
  //   await widget.onLoadMore();
  //   setState(() => _isLoading = false);
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView( // Use SingleChildScrollView to wrap the child
            controller: _scrollController,
            child: widget.child,
          ),
        ),
        // Show loading indicator at the bottom if more data is being loaded
        if (widget.isLoadingMore) ...[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AppLoadingWidget(message: 'Loading more...'),
          ),
        ],
      ],
    );
  }
}





/*
import 'package:flutter/material.dart';
import 'package:movies_app/core/widgets/app_loading_widget.dart';

class LazyLoadListView extends StatefulWidget {
  final Future<void> Function() onLoadMore;
  final Widget child;

  const LazyLoadListView({
    Key? key,
    required this.onLoadMore,
    required this.child,
  }) : super(key: key);

  @override
  _LazyLoadListViewState createState() => _LazyLoadListViewState();
}

class _LazyLoadListViewState extends State<LazyLoadListView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    await widget.onLoadMore();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: widget.child,
          ),
        ),
        if (_isLoading) const AppLoadingWidget(),
      ],
    );
  }
}
*/
