import 'package:flutter/material.dart';

class SeatPosition {
  final int row;
  final int col;

  SeatPosition({required this.row, required this.col});

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
  String? _errorMessage;

  List<SeatPosition> get selectedSeats => _selectedSeats;
  List<SeatPosition> get unavailableSeats => _unavailableSeats;
  double get totalPrice => _totalPrice;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


  Future<void> fetchUnavailableSeats(int movieId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {

      await Future.delayed(const Duration(seconds: 1));
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

  void selectSeat(int row, int col, bool isVip) {
    final seat = SeatPosition(row: row, col: col);
    if (_selectedSeats.contains(seat)) {
      _selectedSeats.remove(seat);
    } else {
      _selectedSeats.add(seat);
    }
    _calculateTotal(isVip);
    notifyListeners();
  }

  void removeSeat(SeatPosition seat) {
    _selectedSeats.remove(seat);
    _recalculateTotalBasedOnCurrentSelection();
    notifyListeners();
  }

  void _recalculateTotalBasedOnCurrentSelection() {
    _totalPrice = _selectedSeats.fold(0, (sum, currentSeat) {
      bool currentSeatIsVip = currentSeat.row >= 0 && currentSeat.row <= 1;
      return sum + (currentSeatIsVip ? 150 : 50);
    });
  }

  void _calculateTotal(bool isVip) {
    _totalPrice = _selectedSeats.fold(0.0, (sum, seat) {
      return sum + (isVip ? 150.0 : 50.0);
    });
  }

  void clearSelection() {
    _selectedSeats = [];
    _totalPrice = 0;
    notifyListeners();
  }

  Future<bool> confirmBooking() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      clearSelection();
      return true;
    } catch (error) {
      _errorMessage = 'Booking failed: $error';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

