import 'package:flutter/material.dart';
import 'package:moviely/utils/routes/routes_name.dart';
import 'package:moviely/views/home/watch_list_view.dart';
import '../../views/bottom_navigation_view.dart';
import '../../views/details.view.dart';
import '../../views/home/home_view.dart';
import '../../views/home/search_view.dart';
import '../../views/splash_view.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> get namedRoutes => {
        RouteNames.home: (BuildContext context) => const HomeView(),
        RouteNames.splash: (BuildContext context) => const SplashView(),
        RouteNames.bottomNav: (BuildContext context) =>
            const BottomNavigationView(),
        RouteNames.search: (BuildContext context) => const SearchView(),
        RouteNames.watchList: (BuildContext context) => const WatchListView(),
        RouteNames.detail: (BuildContext context) => const DetailsView(),
      };
}
