import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../controller/tab_bar_provider.dart';
import '../controller/tmdb_controller.dart';
import '../controller/watch_list_provider.dart';
import '../model/details.dart';
import '../model/movie.dart';
import '../resources/constants/colors.dart';
import '../resources/constants/padding.dart';
import '../resources/widgets/detail_widget.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({
    super.key,
    this.movie = const Movie(
        title: 'Movie Title',
        releaseDate: '0000-00-00',
        rating: '0.0',
        id: '0',
        popularity: 0.0,
        overview: 'No Overview Available'),
    this.details,
  });
  final Movie movie;
  final Details? details;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late TMDBController? _tmdbController;
  late YoutubePlayerController _controller;
  late WatchListProvider _watchListProvider;
  final ValueNotifier<bool> _addToWatchList = ValueNotifier(false);
  @override
  void initState() {
    _watchListProvider = Provider.of<WatchListProvider>(context, listen: false);
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );

    if (widget.details == null) {
      _tmdbController = Provider.of<TMDBController>(context, listen: false);

      _tmdbController!.getMovieDetails(context, widget.movie.id);
    } else {
      _tmdbController = null;
    }

    super.initState();
  }

  @override
  void dispose() {
    _addToWatchList.dispose();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return YoutubePlayerScaffold(
          aspectRatio: 16 / 9,
          controller: _controller,
          builder: (context, player) {
            return Scaffold(
              appBar: _appBar(context),
              body: _detailsBody(cons, player),
            );
          });
    });
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Details',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Provider.of<TabBarProvider>(context, listen: false).setIndex(0);
          Provider.of<TMDBController>(context, listen: false).resetDetails();
          Navigator.pop(context);
        },
      ),
      actions: [
        ValueListenableBuilder(
            valueListenable: _addToWatchList,
            builder: (context, value, child) {
              !_watchListProvider.checkMovie(widget.movie)
                  ? value = true
                  : value = false;
              return IconButton(
                icon: value
                    ? const Icon(Icons.bookmark_border_rounded)
                    : const Icon(Icons.bookmark_outlined),
                onPressed: () async {
                  value
                      ? await _watchListProvider.addMovie(widget.movie)
                      : await _watchListProvider.removeMovie(widget.movie);

                  _addToWatchList.value = !_addToWatchList.value;
                },
              );
            })
      ],
    );
  }

  Widget _detailsBody(BoxConstraints cons, Widget player) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          _backDrop(cons, widget.movie.imageUrl),
          Positioned(
            top: 160,
            right: 10,
            child: _rating(widget.movie.rating),
          ),
          _movieDetails(cons, player),
        ],
      ),
    );
  }

  Widget _backDrop(BoxConstraints cons, String backDropUrl) {
    return CachedNetworkImage(
        imageUrl: backDropUrl,
        placeholder: (context, url) => _placeHolder(cons, context),
        errorWidget: (context, url, error) => _errorWidget(cons),
        errorListener: (exception) {
          debugPrint('Image Error: $exception');
        },
        imageBuilder: (context, imageProvider) {
          return imageContainer(imageProvider);
        });
  }

  Container imageContainer(ImageProvider<Object> imageProvider) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _errorWidget(BoxConstraints cons) {
    return Container(
        width: 150,
        height: cons.maxHeight * 0.28,
        alignment: Alignment.topRight,
        child: const Icon(
          Icons.error,
          color: Colors.red,
        ));
  }

  Container _placeHolder(BoxConstraints cons, BuildContext context) {
    return Container(
      width: 150,
      height: cons.maxHeight * 0.28,
      alignment: Alignment.center,
      child: SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
    );
  }

  Container _rating(String rating) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(37, 40, 54, 0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.star_border,
            size: 20,
            color: AppColors.ratingColor,
          ),
          const SizedBox(width: 3),
          Text(
            rating,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: AppColors.ratingColor),
          ),
        ],
      ),
    );
  }

  _movieDetails(BoxConstraints cons, Widget player) {
    return Padding(
      padding: const EdgeInsets.only(top: 130, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      flex: 2, child: _profileImage(widget.movie.imageUrl)),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 3, child: _movieTitle(cons, widget.movie.title)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              widget.details == null
                  ? Consumer<TMDBController>(
                      builder: (context, provider, child) {
                      return provider.details != null
                          ? _smallDetails(
                              widget.movie.releaseDate,
                              provider.details!.runTime,
                              provider.details!.genre)
                          : _smallDetails(
                              widget.movie.releaseDate, '-- min', 'N/A');
                    })
                  : _smallDetails(widget.movie.releaseDate,
                      widget.details!.runTime, widget.details!.genre),
            ],
          ),
          _tabBar(),
          _tabBarBody(cons, player)
        ],
      ),
    );
  }

  Widget _profileImage(String imageURL) {
    return CachedNetworkImage(
        imageUrl: imageURL,
        errorListener: (exception) {
          debugPrint('Image Error: $exception');
        },
        placeholder: (context, url) => Container(
              width: 120,
              height: 140,
              alignment: Alignment.center,
              child: SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
            ),
        errorWidget: (context, url, error) => Container(
            width: 120,
            height: 140,
            alignment: Alignment.topRight,
            child: const Icon(
              Icons.error,
              color: Colors.red,
            )),
        imageBuilder: (context, imageProvider) {
          return Container(
            // width: (cons.maxHeight * 0.28) / 1.33,
            width: 120,
            height: 140,
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

  SizedBox _movieTitle(BoxConstraints cons, String movieTitle) {
    return SizedBox(
      width: cons.maxWidth * 0.5,
      child: Text(
        movieTitle,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _smallDetails(String releaseYear, String time, String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        DetailWidget(title: releaseYear, icon: Icons.calendar_today_outlined),
        _divider(),
        DetailWidget(title: time, icon: Icons.access_time),
        _divider(),
        DetailWidget(title: category, icon: CupertinoIcons.ticket),
      ],
    );
  }

  Widget _divider() {
    return Text(
      '|',
      style: Theme.of(context)
          .textTheme
          .labelLarge!
          .copyWith(color: AppColors.secondryText),
    );
  }

  Widget _tabBar() {
    return DefaultTabController(
      length: 2,
      initialIndex:
          Provider.of<TabBarProvider>(context, listen: false).currentIndex,
      child: TabBar(
        isScrollable: true,
        labelStyle: Theme.of(context).textTheme.labelSmall,
        labelPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Theme.of(context).primaryColor,
        dividerColor: Theme.of(context).dividerColor,
        onTap: (index) {
          debugPrint('Details View: Tab -> $index');
          Provider.of<TabBarProvider>(context, listen: false).setIndex(index);
        },
        tabs: const <Widget>[
          Tab(
            text: 'About Movie',
          ),
          Tab(
            text: 'Trailer',
          ),
        ],
      ),
    );
  }

  Widget _tabBarBody(BoxConstraints cons, Widget player) {
    return Padding(
      padding: const EdgeInsets.only(top: MyPadding.medium),
      child: Consumer<TabBarProvider>(builder: (context, tabProvider, child) {
        if (tabProvider.currentIndex == 0) {
          return _aboutMovie(widget.movie.overview);
        } else {
          return Consumer<TMDBController>(builder: (context, provider, child) {
            if (provider.details != null) {
              if (_controller.metadata.videoId == '') {
                _controller.loadVideoById(videoId: provider.details!.videoLink);
              }

              return _trailer(cons, player);
            } else {
              return const SizedBox();
            }
          });
        }
      }),
    );
  }

  Widget _aboutMovie(String overview) {
    return SizedBox(
      width: 300,
      child: Text(
        overview,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _trailer(BoxConstraints cons, Widget player) {
    return player;
  }
}
