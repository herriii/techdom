import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'module/home/data_layer/data_sources/movie_database.dart';
import 'module/home/data_layer/data_sources/movie_service.dart';
import 'module/home/data_layer/model/movie_model.dart';
import 'module/home/presentation_layer/provider/movie_provider.dart';
import 'module/home/presentation_layer/view/favourite_screen.dart';
import 'module/home/presentation_layer/view/home_screen.dart';
import 'module/home/presentation_layer/view/movie_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => MovieApiService()),
        Provider(create: (_) => MovieDatabase()),
        ChangeNotifierProvider(
          create: (context) => MovieProvider(
            movieApiService: context.read<MovieApiService>(),
            movieDatabase: context.read<MovieDatabase>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Set your default design dimensions
      builder: (context, child) {
        return MaterialApp(
          title: 'Movies App',
          debugShowCheckedModeBanner: false, // Removes debug banner
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/favourites':
        return MaterialPageRoute(builder: (_) => const FavouritesScreen());
      case '/details':
        // Check if arguments were passed
        if (settings.arguments is Movie) {
          final movie = settings.arguments as Movie;
          return MaterialPageRoute(
            builder: (_) => MovieDetailsScreen(movie: movie),
          );
        }
        return _errorRoute('Invalid arguments for Detail Page');
      default:
        return _errorRoute('Page not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
