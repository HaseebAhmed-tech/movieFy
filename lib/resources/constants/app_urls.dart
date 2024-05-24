import 'package:moviely/resources/constants/api_keys.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppURL {
  static String moviesBaseURL =
      dotenv.env['MOVIES_BASE_URL'] ?? 'MOVIES_BASE_URL not found';
  static String upcomingMoviesEndPoint =
      "$moviesBaseURL/movie/upcoming?language=en-US&page=1";
  static String genresEndPoint = '$moviesBaseURL/genre/movie/list?language=en';
  static String imageBaseUrl =
      dotenv.env['IMAGE_BASE_URL'] ?? 'IMAGE_BASE_URL not found';
  static String getMovieDetailsEndPoint(String movieUrl) =>
      '$moviesBaseURL/movie/$movieUrl?api_key=${ApiKeys.apiKey}&append_to_response=videos';
  static String youtubeBaseUrl =
      dotenv.env['YOUTUBE_BASE_URL'] ?? 'YOUTUBE_BASE_URL not found';
}
