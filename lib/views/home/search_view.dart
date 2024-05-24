import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../controller/searched_list_provider.dart';
import '../../controller/tmdb_controller.dart';
import '../../model/details.dart';
import '../../model/movie.dart';
import '../../resources/constants/padding.dart';
import '../../resources/widgets/minor_detail_cover.dart';
import '../../resources/widgets/text_form_field.dart';
import '../../utils/utils.dart';
import '../details.view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, this.movies});
  final List<Movie>? movies;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late TMDBController _tmdbController;
  @override
  void initState() {
    _tmdbController = Provider.of<TMDBController>(context, listen: false);

    _searchController = TextEditingController();

    _searchController.text =
        Provider.of<SearchedListProvider>(context, listen: false).searchQuery ??
            '';

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
    return _searchBody();
  }

  Widget _searchBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: MyPadding.defaultHorizontalPadding,
            vertical: MyPadding.defaultVerticalPadding),
        child: Column(
          children: [
            _searchBar(),
            const SizedBox(
              height: MyPadding.small,
            ),
            _searchedMovies(),
          ],
        ),
      ),
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
      focusNode: _searchFocusNode,
      onFieldSubmitted: (p0) {
        Provider.of<SearchedListProvider>(context, listen: false)
            .setSearchQuery(
          _searchController.text,
          _searchController.text.isNotEmpty
              ? Utils.searchMovies(
                  match: p0,
                  movies: widget.movies,
                )
              : [],
        );
        Utils.fieldFocusChange(context, _searchFocusNode);
      },
    );
  }

  Widget _searchedMovies() {
    return Expanded(
      child: Consumer<SearchedListProvider>(
        builder: (context, provider, child) {
          return provider.searched.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: provider.searched.map((movie) {
                      return _mapBuilder(context, movie);
                    }).toList(),
                  ),
                )
              : _searchController.text.isNotEmpty
                  ? Center(
                      child: SvgPicture.asset(
                          'assets/images/search_not_found.svg'),
                    )
                  : const SizedBox();
        },
      ),
    );
  }

  FutureBuilder<Details?> _mapBuilder(BuildContext context, Movie? e) {
    return FutureBuilder(
        future: _tmdbController.getMovieDetails(context, e!.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _detailCard(context, snapshot.data, e);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return _detailCard(context, null, e);
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailsView(
              details: details,
              movie: movie,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: MyPadding.small),
        child: MinorDetailCover(
          height: 150,
          width: 100,
          textWidth: MediaQuery.of(context).size.width * 0.5,
          imageUrl: movie.imageUrl,
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
