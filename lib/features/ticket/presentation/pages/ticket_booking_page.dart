
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import for image loading
import '../providers/ticket_booking_provider.dart';
import '../../../movie/data/models/movie_model.dart';
import '../widgets/seat_selection_widget.dart';
import '../../../../core/constants/app_constants.dart'; // Import for image constants
import '../../../../core/widgets/app_loading_widget.dart'; // Import for loading widget

class TicketBookingPage extends StatefulWidget {
  final Movie movie;

  const TicketBookingPage({Key? key, required this.movie}) : super(key: key);

  @override
  _TicketBookingPageState createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  @override
  void initState() {
    super.initState();
    // Fetch unavailable seats when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketProvider>(context, listen: false).fetchUnavailableSeats(widget.movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Tickets')),
      body: ticketProvider.isLoading
          ? const AppLoadingWidget(message: 'Loading seats...') // Show loading widget
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie info header
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding), // Use constant
              child: Row(
                children: [
                  CachedNetworkImage( // Use CachedNetworkImage for movie poster
                    imageUrl: '${AppConstants.tmdbImageBaseUrl}/${AppConstants.imageSizeW500}${widget.movie.posterPath}',
                    width: 80,
                    height: 120, // Add a fixed height for better layout
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movie.title,
                          style: Theme.of(context).textTheme.titleLarge, // Use theme text style
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'In Theaters ${widget.movie.releaseDate}', // Format date if needed
                          style: Theme.of(context).textTheme.bodyMedium, // Use theme text style
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(), // Add a divider for visual separation
            // Seat selection widget
            SeatSelectionWidget(movie: widget.movie),
            const SizedBox(height: AppConstants.defaultPadding),
          ],
        ),
      ),
    );
  }
}

