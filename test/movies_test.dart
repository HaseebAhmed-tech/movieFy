import 'package:flutter_test/flutter_test.dart';
import 'package:moviely/model/movie.dart';
import 'package:moviely/resources/constants/app_urls.dart';

void main() {
  group('Movie Model', () {
    test('fromJson creates a valid Movie object', () {
      final json = {
        "adult": false,
        "backdrop_path": "/fypydCipcWDKDTTCoPucBsdGYXW.jpg",
        "genre_ids": [878, 12, 28],
        "id": 653346,
        "original_language": "en",
        "original_title": "Kingdom of the Planet of the Apes",
        "overview":
            "Several generations in the future following Caesar's reign, apes are now the dominant species and live harmoniously while humans have been reduced to living in the shadows. As a new tyrannical ape leader builds his empire, one young ape undertakes a harrowing journey that will cause him to question all that he has known about the past and to make choices that will define a future for apes and humans alike.",
        "popularity": 1802.132,
        "poster_path": "/gKkl37BQuKTanygYQG1pyYgLVgf.jpg",
        "release_date": "2024-05-08",
        "title": "Kingdom of the Planet of the Apes",
        "video": false,
        "vote_average": 7.201,
        "vote_count": 394
      };

      final movie = Movie.fromJson(json);

      expect(movie.title, 'Kingdom of the Planet of the Apes');
      expect(movie.releaseDate, '2024');
      expect(movie.rating, '7.2');
      expect(movie.id, '653346');
      expect(movie.imageUrl,
          '${AppURL.imageBaseUrl}/gKkl37BQuKTanygYQG1pyYgLVgf.jpg');
      expect(movie.popularity, 1802.132);
      expect(movie.overview,
          "Several generations in the future following Caesar's reign, apes are now the dominant species and live harmoniously while humans have been reduced to living in the shadows. As a new tyrannical ape leader builds his empire, one young ape undertakes a harrowing journey that will cause him to question all that he has known about the past and to make choices that will define a future for apes and humans alike.");
      expect(movie.backDropUrl,
          '${AppURL.imageBaseUrl}/fypydCipcWDKDTTCoPucBsdGYXW.jpg');
    });

    test('fromJson handles missing optional fields with default values', () {
      final json = {
        "title": "Kingdom of the Planet of the Apes",
        "release_date": "2024-05-08",
        "vote_average": 7.201,
        "id": 653346,
        "popularity": 1802.132,
      };

      final movie = Movie.fromJson(json);

      expect(movie.title, "Kingdom of the Planet of the Apes");
      expect(movie.releaseDate, '2024');
      expect(movie.rating, '7.2');
      expect(movie.id, '653346');
      expect(movie.imageUrl,
          'https://via.placeholder.com/200x400'); // Default value
      expect(movie.popularity, 1802.132);
      expect(movie.overview, 'No Overview Available');
      expect(movie.backDropUrl,
          'https://via.placeholder.com/800/350'); // Default value
    });
  });
}
