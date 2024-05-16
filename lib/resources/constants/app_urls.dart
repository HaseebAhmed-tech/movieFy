import 'package:moviely/resources/constants/api_keys.dart';

class AppURL {
  static const String moviesBaseURL = "https://api.themoviedb.org/3";
  static const String upcomingMoviesEndPoint =
      "$moviesBaseURL/movie/upcoming?language=en-US&page=1";
  static const String genresEndPoint =
      '$moviesBaseURL/genre/movie/list?language=en';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static String getMovieDetailsEndPoint(String movieUrl) =>
      '$moviesBaseURL/movie/$movieUrl?api_key=${ApiKeys.apiKey}&append_to_response=videos';
  static String youtubeBaseUrl = 'https://www.youtube.com/watch?v=';
}
