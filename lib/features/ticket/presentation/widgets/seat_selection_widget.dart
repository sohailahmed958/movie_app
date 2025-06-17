import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../movie/data/models/movie_model.dart';
import '../providers/ticket_booking_provider.dart';
import '../../../../core/constants/app_constants.dart'; // Import for constants

class SeatSelectionWidget extends StatelessWidget {
  final Movie movie;

  const SeatSelectionWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(
      builder: (context, ticketProvider, child) {
        // Check for loading or error state from provider
        if (ticketProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ticketProvider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Text(
                'Error: ${ticketProvider.errorMessage}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'SCREEN',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Container(
              height: 10,
              width: MediaQuery.of(context).size.width * 0.8, // Make screen width responsive
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 20),
            // Generate seat layout dynamically
            ...List.generate(8, (row) {
              // Row index from 0 to 7
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Row label (e.g., A, B, C...)
                    SizedBox(
                      width: 20,
                      child: Text(
                        String.fromCharCode(65 + row), // A, B, C, etc.
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Individual seats in a row
                    ...List.generate(10, (col) {
                      // Column index from 0 to 9
                      final isVip = row < 2; // First two rows are VIP
                      final seatPosition = SeatPosition(row: row, col: col);
                      final isSelected = ticketProvider.selectedSeats.contains(seatPosition);
                      final isUnavailable = ticketProvider.unavailableSeats.contains(seatPosition);

                      Color seatColor;
                      if (isUnavailable) {
                        seatColor = Colors.grey; // Unavailable seats
                      } else if (isSelected) {
                        seatColor = Colors.blue; // Selected seats
                      } else {
                        seatColor = isVip ? Colors.orange : Colors.green; // VIP vs Regular
                      }

                      return GestureDetector(
                        onTap: isUnavailable
                            ? null // Cannot select unavailable seats
                            : () => ticketProvider.selectSeat(row, col, isVip),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: seatColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black54),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${col + 1}', // Seat number
                            style: TextStyle(
                              color: isSelected || isUnavailable ? Colors.white : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
            // Legend for seat types - Now using Wrap
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Wrap( // Changed from Row to Wrap
                spacing: 16.0, // Horizontal spacing between items
                runSpacing: 8.0, // Vertical spacing if items wrap to next line
                alignment: WrapAlignment.center, // Align wrapped items in the center
                children: [
                  _buildLegendItem(Colors.green, 'Available (Regular)'),
                  _buildLegendItem(Colors.orange, 'Available (VIP)'),
                  _buildLegendItem(Colors.blue, 'Selected'),
                  _buildLegendItem(Colors.grey, 'Unavailable'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display total price and booking button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${ticketProvider.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: ticketProvider.selectedSeats.isEmpty
                        ? null // Disable button if no seats selected
                        : () => _showBookingConfirmation(context, ticketProvider),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Pay',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
          ],
        );
      },
    );
  }

  // Helper method to build legend items
  Widget _buildLegendItem(Color color, String text) {
    // Removed Expanded here, as Wrap will handle overall spacing/wrapping
    return Row(
      mainAxisSize: MainAxisSize.min, // Ensure inner row takes minimum space
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Flexible( // Keep Flexible for text within the item to allow shrinking/ellipsis
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Shows a confirmation dialog before proceeding to pay
  void _showBookingConfirmation(BuildContext context, TicketProvider ticketProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Movie: ${movie.title}'),
            Text(
              'Seats: ${ticketProvider.selectedSeats.map((s) => '${String.fromCharCode(65 + s.row)}${s.col + 1}').join(', ')}',
            ),
            Text('Total: \$${ticketProvider.totalPrice.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog first
              bool success = await ticketProvider.confirmBooking();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking confirmed!')),
                );
                // Optionally navigate back to movie list or show booking success page
                Navigator.pop(context); // Go back from TicketBookingPage
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ticketProvider.errorMessage ?? 'Booking failed.')),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

