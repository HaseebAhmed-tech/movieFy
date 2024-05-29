// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moviely/model/details.dart';
import 'package:moviely/model/movie.dart';
import 'package:moviely/repository/tmdb_repository.dart';
import 'package:moviely/resources/constants/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class TMDBController extends ChangeNotifier {
  final TMDBRepository _tmdbRepository = TMDBRepository();
  final List<Movie> _moviesData = [];
  Details? details;

  Future<void> getUpcomingMovies(
    BuildContext context,
  ) async {
    final moviesBox = await Hive.openBox('movies');
    moviesBox.clear();
    debugPrint('Upcoming Movies End Point: ${AppURL.upcomingMoviesEndPoint}');
    _tmdbRepository.getUpcomingMovies(AppURL.upcomingMoviesEndPoint).then(
      (value) async {
        debugPrint('Upcoming Result $value');
        int i = 0;
        _moviesData.clear();
        for (var movie in value['results']) {
          // print(object)
          _moviesData.add(Movie.fromJson(movie));

          if (i < 15) {
            moviesBox.put(movie['id'], Movie.fromJson(movie));
          }

          i++;
        }
        debugPrint('Movies Data: ${_moviesData[0].imageUrl}');

        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.bottomNav, (route) => false,
            arguments: {'movies': _moviesData, 'details': null});

        Utils.toastMessage('Welcome to MovieFY');
      },
    ).catchError((error, stack) {
      Utils.flushBarErrorMessage(context, error.toString());
      debugPrint('Movies Data error: $error');
    });
  }

  Future<dynamic> saveMoviesGenres() async {
    debugPrint('Save Movies Genres');
    final value = await _tmdbRepository.getMoviesGenres(AppURL.genresEndPoint);
    debugPrint('Genres Result $value');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('genresList', json.encode(value['genres']));
    return value['genres'];

    // debugPrint('Save Movies Genres Done');
    // return null;
  }

  Future<dynamic> getMoviesGenres() async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint('Genres List: ${prefs.getString('genresList')}');
    if (prefs.getString('genresList') != null) {
      return json.decode(prefs.getString('genresList')!);
    } else {
      final result = await saveMoviesGenres();
      return result;
    }
  }

  getDataFromHive(
      Box<Movie> moviesBox, BuildContext context, Box<Details> detailsBox) {
    if (moviesBox.isNotEmpty) {
      final allMovies = moviesBox.values.toList();
      final allDetails = getDetailsDataFromHive(detailsBox, context);
      debugPrint('All Movies: ${allMovies[0].imageUrl}');
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.bottomNav, (route) => false,
          arguments: {'movies': allMovies, 'details': allDetails});
    } else {
      Utils.flushBarErrorMessage(context, 'No Internet Connection');
    }
  }

  List<Details?> getDetailsDataFromHive(
      Box<Details> detailsBox, BuildContext context) {
    if (detailsBox.isNotEmpty) {
      final allDetails = detailsBox.values.toList();
      return allDetails;
    } else {
      Utils.flushBarErrorMessage(context, 'No Internet Connection');
      return [];
    }
  }

  // Future<Details?> getMovieDetails(
  Future<Details?> getMovieDetails(
    BuildContext? context,
    String? movieId,
  ) async {
    try {
      if (movieId != null) {
        final detailsBox = await Hive.openBox<Details>('details');
        if (detailsBox.containsKey(movieId)) {
          details = detailsBox.get(movieId);
          notifyListeners();
          return details;
        } else {
          try {
            var response = await _tmdbRepository
                .getMovieDetails(AppURL.getMovieDetailsEndPoint(movieId));
            debugPrint('Details should Return: $response');
            if (response != null) {
              details = Details.fromJson(response);
              detailsBox.put(movieId, details!);
              detailsBox.close();
            } else {
              details = null;
              notifyListeners();

              return null;
            }
          } catch (e) {
            return null;
          }
        }
      }

      notifyListeners();
      return details;
    } catch (e) {
      return null;
    }

    // notifyListeners();
  }

  void resetDetails() {
    details = null;
    notifyListeners();
  }
}
