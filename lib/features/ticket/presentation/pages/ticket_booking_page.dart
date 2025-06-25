import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/constants/styles_extension.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/ticket_booking_provider.dart';
import '../../../movie/data/models/movie_model.dart';
import '../widgets/seat_selection_widget.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/utils/date_utils.dart';

class CinemaHallInfo {
  final String time;
  final String hall;
  final String price1;
  final String price2;

  CinemaHallInfo({
    required this.time,
    required this.hall,
    required this.price1,
    required this.price2,
  });
}

class TicketBookingPage extends StatefulWidget {
  final Movie movie;

  const TicketBookingPage({Key? key, required this.movie}) : super(key: key);

  @override
  _TicketBookingPageState createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedHallIndex;

  final List<CinemaHallInfo> _cinemaHalls = [
    CinemaHallInfo(
      time: '12:30',
      hall: 'Cinetech + Hall 1',
      price1: '50\$',
      price2: '2500',
    ),
    CinemaHallInfo(
      time: '13:30',
      hall: 'Cinetech + Hall 2',
      price1: '75\$',
      price2: '3000',
    ),
    CinemaHallInfo(
      time: '14:30',
      hall: 'Grand Cinema',
      price1: '60\$',
      price2: '2800',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedHallIndex = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketProvider>(
        context,
        listen: false,
      ).fetchUnavailableSeats(widget.movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);

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
            Text(
              widget.movie.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'In Theaters ${AppDateUtils.formatDate(DateTime.parse(widget.movie.releaseDate), format: 'MMMM dd,yyyy')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: skyBlueColor,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body:
          ticketProvider.isLoading
              ? const AppLoadingWidget(message: 'Loading seats...')
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 64.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding.w,
                      ),
                      child: Text(
                        'Date',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 35.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding.w,
                        ),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          final date = DateTime.now().add(
                            Duration(days: index),
                          );
                          final isSelected =
                              date.day == _selectedDate.day &&
                              date.month == _selectedDate.month &&
                              date.year == _selectedDate.year;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            child: Container(
                              width: 100.w,
                              margin: EdgeInsets.only(right: 8.w),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? skyBlueColor
                                        : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${AppDateUtils.formatDate(date, format: 'dd')} ',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color:
                                          isSelected ? whiteColor : blackColor,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  Text(
                                    AppDateUtils.formatDate(
                                      date,
                                      format: 'MMM',
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color:
                                          isSelected ? whiteColor : blackColor,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 300.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding.w,
                        ),
                        itemCount: _cinemaHalls.length,
                        itemBuilder: (context, index) {
                          final hallInfo = _cinemaHalls[index];
                          final isSelected = _selectedHallIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedHallIndex = index;
                              });
                            },
                            child: _buildCinemaHallCard(
                              context,
                              hallInfo,
                              isSelected,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 100.h),
                    Center(
                      child: SizedBox(
                        width: context.widthPct(0.8),
                        child: ElevatedButton(
                          onPressed:
                              _selectedHallIndex == null
                                  ? null
                                  : () {
                                    final selectedHall =
                                        _cinemaHalls[_selectedHallIndex!];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => SeatSelectionWidget(
                                              movie: widget.movie,
                                              selectedTime: selectedHall.time,
                                              selectedHallName:
                                                  selectedHall.hall,
                                              selectedDate: _selectedDate,
                                            ),
                                      ),
                                    );
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: skyBlueColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            'Select Seats',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: whiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppConstants.defaultPadding.h),
                  ],
                ),
              ),
    );
  }

  Widget _buildCinemaHallCard(
    BuildContext context,
    CinemaHallInfo hallInfo,
    bool isSelected,
  ) {
    return Container(
      width: 250.w,
      margin: EdgeInsets.only(right: AppConstants.defaultPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: '${hallInfo.time} ',
              style: context.label12500?.copyWith(fontSize: 16.sp),
              children: <TextSpan>[
                TextSpan(
                  text: hallInfo.hall,
                  style: context.label12400?.copyWith(
                    color: greyColor,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 42.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected ? skyBlueColor : Colors.grey[300]!,
                width: 2.w,
              ),
            ),
            child: Image.asset('assets/images/seats.png', fit: BoxFit.cover),
          ),
          SizedBox(height: 14.h),
          RichText(
            text: TextSpan(
              text: 'From ',
              style: context.label12400?.copyWith(
                color: greyColor,
                fontSize: 14.sp,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: hallInfo.price1,
                  style: context.label12500.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                TextSpan(
                  text: ' or ',
                  style: context.label12400.copyWith(
                    color: greyColor,
                    fontSize: 14.sp,
                  ),
                ),
                TextSpan(
                  text: hallInfo.price2,
                  style: context.label12500.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                TextSpan(
                  text: ' bonus',
                  style: context.label12500.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
