import 'package:flutter/material.dart';
import 'package:moviely/model/movie.dart';

class SearchedListProvider extends ChangeNotifier {
  List<Movie?> searched = [];
  String? searchQuery;

  updateSearched(
    List<Movie> newSearched,
  ) {
    searched = newSearched;
    notifyListeners();
  }

  setSearchQuery(String query, List<Movie> newSearched) {
    searched = newSearched;
    searchQuery = query;
    notifyListeners();
  }

  resetSearch() {
    searched = [];
    searchQuery = null;
    notifyListeners();
  }
}
