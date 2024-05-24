import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../controller/bottom_nav_provider.dart';
import '../../controller/searched_list_provider.dart';
import '../../controller/tab_bar_provider.dart';
import '../../controller/tmdb_controller.dart';
import '../../model/details.dart';
import '../../model/movie.dart';
import '../../resources/constants/colors.dart';
import '../../resources/constants/padding.dart';
import '../../resources/widgets/text_form_field.dart';
import '../../utils/utils.dart';
import '../details.view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.movies, this.details});
  final List<Movie>? movies;
  final List<Details?>? details;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TextEditingController _searchController;
  late final List<Movie> _topMovies;
  late TMDBController _tmdbController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    if (widget.movies != null) {
      Utils.sortOnPopularity(widget.movies!, 0, widget.movies!.length - 1);
      _topMovies = widget.movies!
          .sublist(widget.movies!.length > 6 ? widget.movies!.length - 5 : 0);
    }

    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        _tmdbController = Provider.of<TMDBController>(context, listen: false);

        Utils.checkInternetConnectivity().then((value) {
          if (value) {
            debugPrint('Internet Connected');

            _tmdbController.getUpcomingMovies(context);
          } else {
            debugPrint('No Internet');
            Utils.toastMessage('No Internet Connection');
          }
        });
      },
      child: _homeBody(),
    );
  }

  Widget _homeBody() {
    return widget.movies != null
        ? LayoutBuilder(
            builder: (context, cons) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: MyPadding.defaultHorizontalPadding,
                      vertical: MyPadding.defaultVerticalPadding),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _topText(),
                        const SizedBox(height: MyPadding.medium),
                        _searchBar(),
                        const SizedBox(height: MyPadding.large),
                        SizedBox(
                          height: cons.maxHeight * 0.30,
                          child: _trendingMovies(cons),
                        ),
                        const SizedBox(height: MyPadding.large),
                        _topBarSection(cons),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _topText() {
    return Text(
      'What do you want to watch?',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _searchBar() {
    return MyTextFormField(
      controller: _searchController,
      labelText: 'Search',
      suffixIcon: SvgPicture.asset(
        'assets/icons/search.svg',
        height: 10,
        width: 10,
        fit: BoxFit.scaleDown,
      ),
      // focusNode: _searchFocusNode,
      onFieldSubmitted: (p0) {
        Provider.of<SearchedListProvider>(context, listen: false)
            .setSearchQuery(
                _searchController.text,
                _searchController.text.isNotEmpty
                    ? Utils.searchMovies(
                        match: p0,
                        movies: widget.movies,
                      )
                    : []);
        Utils.fieldFocusChange(context, _searchFocusNode);
        Provider.of<BottomNavigationProvider>(context, listen: false)
            .setIndex(1);
      },
    );
  }

  Widget _trendingMovies(BoxConstraints cons) {
    return ListView.builder(
        itemCount: _topMovies.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsView(
                        movie: _topMovies[index],
                        details: Utils.getDetailsFormMovies(
                            _topMovies[index], widget.details))),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: MyPadding.small),
              child: SizedBox(
                width: 160,
                child: _trendingMovieWidget(index, cons, context),
              ),
            ),
          );
        });
  }

  Stack _trendingMovieWidget(
      int index, BoxConstraints cons, BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      clipBehavior: Clip.antiAlias,
      children: [
        _trendingImage(index, cons),
        Positioned(bottom: -20, left: 0, child: _trendingCount(index, context))
      ],
    );
  }

  Text _trendingCount(int index, BuildContext context) {
    return Text(
      '${index + 1}',
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
        fontFamily: 'Montserrat',
        color: Theme.of(context).scaffoldBackgroundColor,
        decorationStyle: TextDecorationStyle.solid,
        shadows: [
          const Shadow(
            blurRadius: 0.0,
            color: Colors.blue,
            offset: Offset(-1.2, -1.2),
          ),
          const Shadow(
            blurRadius: 0.10,
            color: Colors.blue,
            offset: Offset(1.2, 1.2),
          ),
        ],
      ),
    );
  }

  CachedNetworkImage _trendingImage(int index, BoxConstraints cons) {
    return CachedNetworkImage(
        imageUrl: _topMovies[index].imageUrl,
        errorListener: (exception) {
          debugPrint('Image Error: $exception');
        },
        placeholder: (context, url) => Container(
              width: 150,
              height: cons.maxHeight * 0.28,
              alignment: Alignment.center,
              child: SpinKitRipple(color: Theme.of(context).primaryColor),
            ),
        errorWidget: (context, url, error) => Container(
            width: 150,
            height: cons.maxHeight * 0.28,
            alignment: Alignment.topRight,
            child: const Icon(
              Icons.error,
              color: Colors.red,
            )),
        imageBuilder: (context, imageProvider) {
          return Container(
            // width: (cons.maxHeight * 0.28) / 1.33,
            width: 150,
            height: cons.maxHeight * 0.28,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.textFormFieldFillColor,
            ),
            child: Image(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          );
        });
  }

  Widget _topBarSection(BoxConstraints cons) {
    return SizedBox(
      height: cons.maxHeight * 0.65,
      child: OrientationBuilder(builder: (context, orientation) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          primary: false,
          slivers: <Widget>[
            _scrollabaleTabHeaders(context),
            _tabElementsGrid(orientation)
          ],
        );
      }),
    );
  }

  SliverPadding _tabElementsGrid(Orientation orientation) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: MyPadding.medium),
      sliver: Consumer<TabBarProvider>(
        builder: (context, provider, child) {
          debugPrint('Home View: Tab Index -> ${provider.currentIndex}');
          switch (provider.currentIndex) {
            case (0):
              return _upcomingMovies(orientation);

            default:
              return SliverToBoxAdapter(
                child: Container(
                  height: 100.0,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              );
          }
        },
      ),
    );
  }

  SliverAppBar _scrollabaleTabHeaders(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      primary: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pinned: true, // Keep the app bar visible when scrolling
      floating: true,

      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        title: DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: TabBar(
            isScrollable: true,
            labelStyle: Theme.of(context).textTheme.labelSmall,
            labelPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
            unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Theme.of(context).primaryColor,
            dividerColor: Theme.of(context).dividerColor,
            onTap: (index) {
              debugPrint('Home View: Tab -> $index');
              Provider.of<TabBarProvider>(context, listen: false)
                  .setIndex(index);
            },
            tabs: _tabBarTabs,
          ),
        ),
      ), // Disable floating behavior
    );
  }

  SliverGrid _upcomingMovies(Orientation orientation) {
    return SliverGrid.builder(
      itemCount: widget.movies?.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: orientation == Orientation.portrait ? 3 : 5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: orientation == Orientation.portrait ? 0.65 : 0.9),
      itemBuilder: (context, index) {
        return _upcomingMovieElement(context, index);
      },
    );
  }

  InkWell _upcomingMovieElement(BuildContext context, int index) {
    return InkWell(
        onTap: () {
          Provider.of<TabBarProvider>(context, listen: false).setIndex(0);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsView(
                      movie: widget.movies![index],
                      details: Utils.getDetailsFormMovies(
                          widget.movies![index], widget.details),
                    )),
          );
        },
        child: cardOutline(widget.movies![index].imageUrl));
  }

  List<Widget> get _tabBarTabs {
    return const <Widget>[
      Tab(
        text: 'Upcoming',
      ),
      Tab(
        text: 'Now Playing',
      ),
      Tab(
        text: 'Top Rated',
      ),
      Tab(
        text: 'Popular',
      ),
    ];
  }

  Widget cardOutline(String url) {
    try {
      return CachedNetworkImage(
          imageUrl: url,
          errorListener: (exception) {
            debugPrint('Image Error: $exception');
          },
          placeholder: (context, url) => Container(
                alignment: Alignment.center,
                child: SpinKitRipple(color: Theme.of(context).primaryColor),
              ),
          errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                color: AppColors.textFormFieldFillColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.topRight,
              child: const Icon(
                Icons.error,
                color: Colors.red,
              )),
          imageBuilder: (context, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.textFormFieldFillColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            );
          });
    } catch (e) {
      return const SizedBox();
    }
  }
}
