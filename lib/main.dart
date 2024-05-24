import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moviely/controller/bottom_nav_provider.dart';
import 'package:moviely/controller/full_screen_provider.dart';
import 'package:moviely/controller/searched_list_provider.dart';
import 'package:moviely/controller/tab_bar_provider.dart';
import 'package:moviely/controller/theme_provider.dart';
import 'package:moviely/controller/tmdb_controller.dart';
import 'package:moviely/model/Adapter/details_adapter.dart';
import 'package:moviely/model/details.dart';
import 'package:moviely/utils/routes/routes.dart';
import 'package:moviely/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'controller/watch_list_provider.dart';
import 'model/Adapter/movie_adapter.dart';
import 'model/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint(e.toString());
  }
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  // print('Hive cHECK');
  Hive.registerAdapter<Movie>(MovieAdapter(), override: true);
  Hive.registerAdapter<Details>(DetailsAdapter(), override: true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<BottomNavigationProvider>(
          create: (context) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TabBarProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TMDBController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FullScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchedListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WatchListProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeProvider.themeData,
      initialRoute: RouteNames.splash,
      routes: Routes.namedRoutes,
    );
  }
}
