import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../controller/tmdb_controller.dart';
import '../../controller/watch_list_provider.dart';
import '../../model/details.dart';
import '../../model/movie.dart';
import '../../resources/constants/padding.dart';
import '../../resources/widgets/minor_detail_cover.dart';
import '../details.view.dart';

class WatchListView extends StatefulWidget {
  const WatchListView({super.key, this.movies, this.details});
  final List<Movie>? movies;
  final List<Details?>? details;

  @override
  State<WatchListView> createState() => _WatchListViewState();
}

class _WatchListViewState extends State<WatchListView> {
  late TMDBController _tmdbController;
  @override
  void initState() {
    _tmdbController = Provider.of<TMDBController>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _watchListBody();
  }

  Widget _watchListBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: MyPadding.defaultHorizontalPadding,
            vertical: MyPadding.defaultVerticalPadding),
        child: Column(
          children: [
            const SizedBox(
              height: MyPadding.small,
            ),
            _watchListMovies(),
          ],
        ),
      ),
    );
  }

  Widget _watchListMovies() {
    return Expanded(
      child: Consumer<WatchListProvider>(
        builder: (context, provider, child) {
          return provider.getWatchList().isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: provider.getWatchList().map((movie) {
                      return _mapBuilder(context, movie);
                    }).toList(),
                  ),
                )
              : Center(
                  child: SvgPicture.asset('assets/images/empty_wishlist.svg'),
                );
        },
      ),
    );
  }

  FutureBuilder<Details?> _mapBuilder(BuildContext context, Movie e) {
    return FutureBuilder(
        future: _tmdbController.getMovieDetails(context, e.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _detailCard(context, snapshot.data, e);
          }

          if (snapshot.data == null) {
            return _detailCard(context, snapshot.data, e);
          }

          return const SizedBox();
        });
  }

  GestureDetector _detailCard(
    BuildContext context,
    Details? details,
    Movie movie,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => DetailsView(
                  details: null,
                  movie: movie,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: MyPadding.small),
        child: MinorDetailCover(
          imageUrl: movie.imageUrl,
          height: 150,
          width: 100,
          textWidth: MediaQuery.of(context).size.width * 0.5,
          movieTitle: movie.title,
          movieCategory: details != null ? details.genre : 'N/A',
          releaseDate: movie.releaseDate,
          movieLength: details != null ? details.runTime : '-- min',
          rating: movie.rating,
        ),
      ),
    );
  }
}
