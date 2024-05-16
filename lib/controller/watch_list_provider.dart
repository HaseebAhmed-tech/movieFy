import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/movie.dart';

class WatchListProvider extends ChangeNotifier {
  final List<Movie> _watchList = [];

  Future<void> addMovie(Movie movie) async {
    final watchListBox = await Hive.openBox<Movie>('watch-list');

    _watchList.add(movie);

    watchListBox.put(movie.id, movie);
    watchListBox.close();
    notifyListeners();
  }

  bool checkMovie(Movie movie) {
    return _watchList.any((element) {
      return element.id == movie.id;
    });
  }

  Future<void> removeMovie(Movie movie) async {
    final watchListBox = await Hive.openBox<Movie>('watch-list');

    _watchList.remove(movie);
    watchListBox.delete(movie.id);
    watchListBox.close();

    notifyListeners();
  }

  void clearList() async {
    final watchListBox = await Hive.openBox<Movie>('watch-list');
    _watchList.clear();
    watchListBox.clear();
    watchListBox.close();
  }

  List<Movie> getWatchList() {
    return _watchList;
  }

  Future<void> setWatchListWithHive() async {
    final watchListBox = await Hive.openBox<Movie>('watch-list');
    List<Movie> hiveWatchList = watchListBox.values.toList();
    if (hiveWatchList.isNotEmpty) {
      _watchList.addAll(hiveWatchList);
      notifyListeners();
      watchListBox.close();
    }
  }
}
