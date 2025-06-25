import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/styles_extension.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../movie/data/models/movie_model.dart';
import '../providers/ticket_booking_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_utils.dart';

class SeatSelectionWidget extends StatelessWidget {
  final Movie movie;
  final DateTime selectedDate;
  final String selectedTime;
  final String selectedHallName;

  const SeatSelectionWidget({
    super.key,
    required this.selectedDate,
    required this.movie,
    required this.selectedTime,
    required this.selectedHallName,
  });

  @override
  Widget build(BuildContext context) {
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
        title: Column(
          children: [
            Text(movie.title, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              "${AppDateUtils.formatDate(selectedDate, format: 'MMMM dd,yyyy')} | $selectedTime $selectedHallName",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: skyBlueColor,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Consumer<TicketProvider>(
        builder: (context, ticketProvider, child) {
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
              SizedBox(height: 18.h),
              // SCREEN Indicator
              Image.asset(
                'assets/icons/screen_img.png',
              ), // Ensure this asset exists
              Text(
                'SCREEN',
                style: context.label8500.copyWith(color: greyColor),
              ),

              SizedBox(height: 30.h),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding.w,
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: List.generate(
                            10,
                            (rowIndex) => Column(
                              children: [
                                SizedBox(height: 7.h),
                                Text(
                                  '${rowIndex + 1}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(10, (rowIndex) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 8.w),
                                if (rowIndex == 0) ...[
                                  _buildSeatBlock(
                                    context,
                                    10,
                                    rowIndex,
                                    0,
                                    ticketProvider,
                                  ),
                                ] else if (rowIndex >= 1 && rowIndex <= 4) ...[
                                  _buildSeatBlock(
                                    context,
                                    5,
                                    rowIndex,
                                    0,
                                    ticketProvider,
                                  ),
                                  SizedBox(width: 26.w),
                                  _buildSeatBlock(
                                    context,
                                    5,
                                    rowIndex,
                                    5,
                                    ticketProvider,
                                  ),
                                  SizedBox(width: 26.w),
                                  _buildSeatBlock(
                                    context,
                                    5,
                                    rowIndex,
                                    10,
                                    ticketProvider,
                                  ),
                                ] else ...[
                                  _buildSeatBlock(
                                    context,
                                    7,
                                    rowIndex,
                                    0,
                                    ticketProvider,
                                  ),
                                  SizedBox(width: 26.w),
                                  _buildSeatBlock(
                                    context,
                                    6,
                                    rowIndex,
                                    7,
                                    ticketProvider,
                                  ),
                                  SizedBox(width: 26.w),
                                  _buildSeatBlock(
                                    context,
                                    7,
                                    rowIndex,
                                    13,
                                    ticketProvider,
                                  ),
                                ],
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding.w,
                ),
                child: Container(
                  height: 10.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'zoomOutFabUniqueTag',
                      elevation: 0,
                      onPressed: () {
                        // Implement zoom out
                      },
                      backgroundColor: whiteColor,
                      foregroundColor: blackColor,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.remove),
                    ),
                    SizedBox(width: 10.w),
                    FloatingActionButton.small(
                      heroTag: 'zoomInFabUniqueTag', // Unique tag
                      elevation: 0,
                      onPressed: () {
                        // Implement zoom in
                      },
                      backgroundColor: whiteColor,
                      foregroundColor: blackColor,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              const Divider(indent: 20, endIndent: 20),
              SizedBox(height: 10.h),
              // Legend
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Row(
                  children: [
                    _buildLegendItem(
                      context,
                      'assets/icons/selected.png',
                      'Selected',
                    ),
                    Spacer(),
                    _buildLegendItem(
                      context,
                      'assets/icons/not_avail.png',
                      'Not available',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Row(
                  children: [
                    _buildLegendItem(
                      context,
                      'assets/icons/vip.png',
                      'VIP (150\$)',
                    ),
                    Spacer(),
                    _buildLegendItem(
                      context,
                      'assets/icons/regular.png',
                      'Regular (50\$)',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              // Selected Seats Display
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding.w,
                ),
                child: Row(
                  children: [
                    if (ticketProvider.selectedSeats.isNotEmpty)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 4.h,
                              children:
                                  ticketProvider.selectedSeats.map((s) {
                                    return Chip(
                                      backgroundColor: midGreyColor,
                                      label: Text(
                                        '${String.fromCharCode(65 + s.row)}${s.col + 1}',
                                        style: context.label14500.copyWith(
                                          color: blackColor,
                                        ),
                                      ),
                                      deleteIcon: Icon(
                                        Icons.close,
                                        size: 18.w,
                                        color: Colors.black54,
                                      ),
                                      onDeleted: () {
                                        ticketProvider.removeSeat(s);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: AppConstants.defaultPadding.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: midGreyColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Price', style: context.label10400),
                          Text(
                            '\$${ticketProvider.totalPrice.toStringAsFixed(2)}',
                            style: context.label16600,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed:
                          ticketProvider.selectedSeats.isEmpty
                              ? null
                              : () => _showBookingConfirmation(
                                context,
                                ticketProvider,
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: skyBlueColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 15.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Proceed to pay',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstants.defaultPadding.h),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSeatBlock(
    BuildContext context,
    int count,
    int rowIndex,
    int startCol,
    TicketProvider ticketProvider,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final colIndex = startCol + index;

        Color baseSeatColor;
        bool isVipType = false;
        if (rowIndex >= 0 && rowIndex <= 0) {
          baseSeatColor = greyColor;
          isVipType = true;
        } else if (rowIndex >= 1 && rowIndex <= 4) {
          baseSeatColor = skyBlueColor;
        } else {
          baseSeatColor = blueColor;
        }

        final seatPosition = SeatPosition(row: rowIndex, col: colIndex);
        final isSelected = ticketProvider.selectedSeats.contains(seatPosition);
        final isUnavailable = ticketProvider.unavailableSeats.contains(
          seatPosition,
        );

        Color finalSeatColor;
        if (isUnavailable) {
          finalSeatColor = pinkColor;
        } else if (isSelected) {
          finalSeatColor = yellowColor;
        } else {
          finalSeatColor = baseSeatColor;
        }

        return GestureDetector(
          onTap:
              isUnavailable
                  ? null
                  : () =>
                      ticketProvider.selectSeat(rowIndex, colIndex, isVipType),
          child: Container(
            margin: EdgeInsets.all(3.w),
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: finalSeatColor,
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLegendItem(BuildContext context, String img, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(img),
        SizedBox(width: 8.w),
        Text(text, style: context.label12500.copyWith(color: greyColor)),
      ],
    );
  }

  void _showBookingConfirmation(
    BuildContext context,
    TicketProvider ticketProvider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Booking'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Movie: ${movie.title}',
                  style: TextStyle(fontSize: 16.sp),
                ),
                Text(
                  'Seats: ${ticketProvider.selectedSeats.map((s) => '${String.fromCharCode(65 + s.row)}${s.col + 1}').join(', ')}',
                  style: TextStyle(fontSize: 14.sp),
                ),
                Text(
                  'Total: \$${ticketProvider.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  bool success = await ticketProvider.confirmBooking();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking confirmed!')),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ticketProvider.errorMessage ?? 'Booking failed.',
                        ),
                      ),
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
