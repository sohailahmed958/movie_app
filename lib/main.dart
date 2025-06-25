
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/injection_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/movie/presentation/pages/movie_list_page.dart';
import 'features/movie/presentation/providers/movie_provider.dart';
import 'features/search/presentation/providers/search_provider.dart';
import 'features/ticket/presentation/providers/ticket_booking_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => sl<MovieProvider>()),
            ChangeNotifierProvider(create: (_) => sl<SearchProvider>()),
            ChangeNotifierProvider(create: (_) => sl<TicketProvider>()),
            ChangeNotifierProvider(create: (_) => sl<ThemeProvider>()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'Movie App',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.themeData,
                themeMode: themeProvider.themeMode,
                home: const MovieListScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
