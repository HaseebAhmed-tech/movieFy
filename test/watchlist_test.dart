import 'package:flutter_test/flutter_test.dart';
import 'package:moviely/controller/watch_list_provider.dart';
import 'package:moviely/model/movie.dart';

void main() {
  group('WatchListProvider', () {
    test('Adding a movie to the watch list', () async {
      final watchListProvider = WatchListProvider();
      const movie = Movie(
        title: 'Inception',
        releaseDate: '2010',
        rating: '8.8',
        id: '123',
        popularity: 9.5,
      );

      await watchListProvider.addMovie(movie);

      expect(watchListProvider.getWatchList(), contains(movie));
    });
  });
  test('Checking if a movie exists in the watch list', () {
    final watchListProvider = WatchListProvider();
    const movie = Movie(
      title: 'The Matrix',
      releaseDate: '1999',
      rating: '8.7',
      id: '456',
      popularity: 9.0,
    );

    watchListProvider.addMovie(movie);

    expect(watchListProvider.checkMovie(movie), isTrue);
  });

  test('Removing a movie from the watch list', () async {
    final watchListProvider = WatchListProvider();
    const movie = Movie(
      title: 'Interstellar',
      releaseDate: '2014',
      rating: '8.6',
      id: '789',
      popularity: 8.9,
    );

    await watchListProvider.addMovie(movie);
    await watchListProvider.removeMovie(movie);

    expect(watchListProvider.getWatchList(), isNot(contains(movie)));
  });

  test('Setting the watch list with Hive', () async {
    final watchListProvider = WatchListProvider();
    const movie1 = Movie(
      title: 'Interstellar',
      releaseDate: '2014',
      rating: '8.6',
      id: '789',
      popularity: 8.9,
    ); // Create a sample movie
    const movie2 = Movie(
      title: 'King Kong',
      releaseDate: '2011',
      rating: '8.0',
      id: '139',
      popularity: 9.0,
    ); // Create another sample movie

    await watchListProvider.addMovie(movie1);
    await watchListProvider.addMovie(movie2);

    await watchListProvider.setWatchListWithHive();

    expect(watchListProvider.getWatchList(), containsAll([movie1, movie2]));
  });
}
