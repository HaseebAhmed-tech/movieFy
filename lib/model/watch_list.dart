import 'movie.dart';

class WatchList {
  static final List<Movie> _watchList = [];
  static void addMovie(Movie movie) {
    _watchList.add(movie);
  }

  static bool checkMovie(Movie movie) {
    return _watchList.any((element) {
      return element.id == movie.id;
    });
  }

  static void removeMovie(Movie movie) {
    _watchList.remove(movie);
  }

  static void clearList() {
    _watchList.clear();
  }

  static List<Movie> getWatchList() {
    return _watchList;
  }
}
