import 'package:moviely/model/details.dart';
import 'package:moviely/utils/utils.dart';

import '../resources/constants/app_urls.dart';

class Movie {
  final String title;
  final String releaseDate;
  final String rating;
  final String id;
  final String imageUrl;
  final double popularity;
  final String overview;
  final String backDropUrl;
  final Details? details;

  const Movie({
    required this.title,
    required this.releaseDate,
    required this.rating,
    required this.id,
    this.imageUrl = 'https://via.placeholder.com/200x400',
    required this.popularity,
    this.overview = 'No Overview Available',
    this.backDropUrl = 'https://via.placeholder.com/800/350',
    this.details,
  });
  Movie.fromJson(Map<String, dynamic> json, {this.details})
      : title = json['title'],
        releaseDate = json['release_date'].split('-')[0],
        rating = Utils.roundStringDouble(
          json['vote_average'].toString(),
          decimalPlaces: 1,
        ),
        id = json['id'].toString(),
        imageUrl = '${AppURL.imageBaseUrl}${json['poster_path']}',
        popularity = json['popularity'],
        overview = json['overview'],
        backDropUrl = '${AppURL.imageBaseUrl}${json['backdrop_path']}';
}
