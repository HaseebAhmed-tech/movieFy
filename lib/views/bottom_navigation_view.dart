import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../controller/bottom_nav_provider.dart';
import '../controller/watch_list_provider.dart';
import '../model/details.dart';
import '../model/movie.dart';
import '../resources/constants/padding.dart';
import '../utils/utils.dart';

class BottomNavigationView extends StatefulWidget {
  const BottomNavigationView({super.key});

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  late WatchListProvider _watchListProvider;

  @override
  void initState() {
    _watchListProvider = Provider.of<WatchListProvider>(context, listen: false);
    _watchListProvider.setWatchListWithHive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<Movie> movies = arguments['movies'];
    List<Details?>? details = arguments['details'];
    return Consumer<BottomNavigationProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: bottomNavigationBar(context, provider),
        body: Utils.generateViewsList(movies, details)[provider.currentIndex],
      );
    });
  }

  Container bottomNavigationBar(
      BuildContext context, BottomNavigationProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: MyPadding.extraSmall),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.setIndex(index);
        },
        items: <BottomNavigationBarItem>[
          _homeNavBarElement(provider, context),
          _searchNavBarElement(provider, context),
          _watchLaterElement(),
        ],
      ),
    );
  }

  BottomNavigationBarItem _watchLaterElement() {
    return const BottomNavigationBarItem(
      icon: Icon(Icons.bookmark_border_rounded),
      label: 'Watch Later',
    );
  }

  BottomNavigationBarItem _searchNavBarElement(
      BottomNavigationProvider provider, BuildContext context) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/icons/search.svg',
        colorFilter: provider.currentIndex == 1
            ? ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn)
            : ColorFilter.mode(
                Theme.of(context).unselectedWidgetColor, BlendMode.srcIn),
      ),
      label: 'Search',
    );
  }

  BottomNavigationBarItem _homeNavBarElement(
      BottomNavigationProvider provider, BuildContext context) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/icons/home.svg',
        height: 20,
        width: 20,
        colorFilter: provider.currentIndex == 0
            ? ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn)
            : ColorFilter.mode(
                Theme.of(context).unselectedWidgetColor, BlendMode.srcIn),
        fit: BoxFit.scaleDown,
      ),
      label: 'Home',
    );
  }
}
