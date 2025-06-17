
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/injection_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/movie/presentation/pages/movie_list_page.dart';
import 'features/movie/presentation/providers/movie_provider.dart';
import 'features/search/presentation/providers/search_provider.dart';
import 'features/ticket/presentation/providers/ticket_booking_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load environment variables from .env file
  await init(); // Initialize GetIt dependencies

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit for responsive design
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Design resolution
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // MultiProvider to supply various providers to the widget tree
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => sl<MovieProvider>()),
            ChangeNotifierProvider(create: (_) => sl<SearchProvider>()),
            ChangeNotifierProvider(create: (_) => sl<TicketProvider>()),
            ChangeNotifierProvider(create: (_) => sl<ThemeProvider>()), // Provide ThemeProvider
          ],
          child: Consumer<ThemeProvider>( // Use Consumer to rebuild when theme changes
            builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'Movie App',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme(context), // Apply light theme
                darkTheme: AppTheme.darkTheme(context), // Apply dark theme
                themeMode: themeProvider.themeMode, // Control theme mode
                home: const MovieListScreen(), // Set initial screen
              );
            },
          ),
        );
      },
    );
  }
}
