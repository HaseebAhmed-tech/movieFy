import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moviely/controller/searched_list_provider.dart';
import 'package:moviely/controller/tmdb_controller.dart';
import 'package:moviely/resources/widgets/minor_detail_cover.dart';
import 'package:moviely/resources/widgets/text_form_field.dart';
import 'package:moviely/utils/utils.dart';
import 'package:moviely/views/details.view.dart';
import 'package:provider/provider.dart';

import '../../model/details.dart';
import '../../model/movie.dart';
import '../../resources/constants/padding.dart';

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
      // onChanged: (value) {
      //   debugPrint('Search View: Search -> $value');
      // },
      onFieldSubmitted: (p0) {
        Provider.of<SearchedListProvider>(context, listen: false)
            .updateSearched(_searchController.text.isNotEmpty
                ? widget.movies!.where((element) {
                    return element.title
                        .toLowerCase()
                        .contains(p0.toLowerCase().trim());
                  }).toList()
                : []);
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
                    children: provider.searched.map((e) {
                      // _tmdbController.getMovieDetails(context, e!.id).then(
                      //   (value) {
                      // print('Search View: Details -> $value');
                      return FutureBuilder(
                          future:
                              _tmdbController.getMovieDetails(context, e!.id),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return _detailCard(context, snapshot.data, e);
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data == null) {
                                return _detailCard(context, null, e);
                              }
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            return const SizedBox();
                          });
                      //   },
                      // );
                      // return const CircularProgressIndicator();
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

  GestureDetector _detailCard(
    BuildContext context,
    Details? details,
    Movie movie,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => DetailsView(
                  details: details,
                  movie: movie,
                )));
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
