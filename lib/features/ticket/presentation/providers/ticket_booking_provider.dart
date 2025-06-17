import 'package:flutter/material.dart';

class SeatPosition {
  final int row;
  final int col;

  SeatPosition({required this.row, required this.col});

  // Override equals and hashCode for proper comparison in lists/sets
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SeatPosition &&
              runtimeType == other.runtimeType &&
              row == other.row &&
              col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

class TicketProvider with ChangeNotifier {
  List<SeatPosition> _selectedSeats = [];
  List<SeatPosition> _unavailableSeats = [];
  double _totalPrice = 0;
  bool _isLoading = false;
  String? _errorMessage; // Added for error handling

  List<SeatPosition> get selectedSeats => _selectedSeats;
  List<SeatPosition> get unavailableSeats => _unavailableSeats;
  double get totalPrice => _totalPrice;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetches unavailable seats (simulated API call)
  Future<void> fetchUnavailableSeats(int movieId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1)); // Reduced delay
      // Simulate some unavailable seats
      _unavailableSeats = [
        SeatPosition(row: 0, col: 1),
        SeatPosition(row: 2, col: 3),
        SeatPosition(row: 3, col: 5),
        SeatPosition(row: 5, col: 8),
        SeatPosition(row: 7, col: 0),
        SeatPosition(row: 7, col: 1),
      ];
    } catch (error) {
      _errorMessage = 'Failed to fetch unavailable seats: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggles seat selection
  void selectSeat(int row, int col, bool isVip) {
    final seat = SeatPosition(row: row, col: col);
    if (_selectedSeats.contains(seat)) { // Use contains and remove for better readability
      _selectedSeats.remove(seat);
    } else {
      _selectedSeats.add(seat);
    }
    _calculateTotal(isVip);
    notifyListeners();
  }

  // Calculates total price based on selected seats and VIP status
  void _calculateTotal(bool isVip) {
    _totalPrice = _selectedSeats.fold(0.0, (sum, seat) {
      // Assign specific prices for VIP and regular seats
      return sum + (isVip ? 150.0 : 50.0);
    });
  }

  // Clears all selected seats
  void clearSelection() {
    _selectedSeats = [];
    _totalPrice = 0;
    notifyListeners();
  }

  // Simulates confirming the booking
  Future<bool> confirmBooking() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call for booking confirmation
      await Future.delayed(const Duration(seconds: 2));
      // In a real app, you would send the selected seats to your backend here
      // If successful, clear selection
      clearSelection();
      return true; // Booking successful
    } catch (error) {
      _errorMessage = 'Booking failed: $error';
      return false; // Booking failed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

