import 'package:flutter_test/flutter_test.dart';
import 'package:moviely/model/details.dart';

void main() {
  group('Details Model', () {
    test('fromJson creates a valid Details object', () {
      final json = {
        "adult": false,
        "backdrop_path": "/fqv8v6AycXKsivp1T5yKtLbGXce.jpg",
        "belongs_to_collection": {
          "id": 173710,
          "name": "Planet of the Apes (Reboot) Collection",
          "poster_path": "/afGkMC4HF0YtXYNkyfCgTDLFe6m.jpg",
          "backdrop_path": "/2ZkvqfOJUCINozB00wmYuGJQW81.jpg"
        },
        "budget": 160000000,
        "genres": [
          {"id": 878, "name": "Science Fiction"},
          {"id": 12, "name": "Adventure"},
        ],
        "homepage":
            "https://www.20thcenturystudios.com/movies/kingdom-of-the-planet-of-the-apes",
        "id": 653346,
        "imdb_id": "tt11389872",
        "origin_country": ["US"],
        "original_language": "en",
        "original_title": "Kingdom of the Planet of the Apes",
        "overview":
            "Several generations in the future following Caesar's reign, apes are now the dominant species and live harmoniously while humans have been reduced to living in the shadows. As a new tyrannical ape leader builds his empire, one young ape undertakes a harrowing journey that will cause him to question all that he has known about the past and to make choices that will define a future for apes and humans alike.",
        "popularity": 1802.132,
        "poster_path": "/gKkl37BQuKTanygYQG1pyYgLVgf.jpg",
        "production_companies": [
          {
            "id": 127928,
            "logo_path": "/h0rjX5vjW5r8yEnUBStFarjcLT4.png",
            "name": "20th Century Studios",
            "origin_country": "US"
          },
          {
            "id": 133024,
            "logo_path": null,
            "name": "Oddball Entertainment",
            "origin_country": "US"
          },
          {
            "id": 89254,
            "logo_path": null,
            "name": "Jason T. Reed Productions",
            "origin_country": "US"
          }
        ],
        "production_countries": [
          {"iso_3166_1": "US", "name": "United States of America"}
        ],
        "release_date": "2024-05-08",
        "revenue": 145000000,
        "runtime": 145,
        "spoken_languages": [
          {"english_name": "English", "iso_639_1": "en", "name": "English"}
        ],
        "status": "Released",
        "tagline": "No one can stop the reign.",
        "title": "Kingdom of the Planet of the Apes",
        "video": false,
        "vote_average": 7.204,
        "vote_count": 399,
        "videos": {
          "results": [
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Hidden Talent",
              "key": "ne7fE34kPug",
              "site": "YouTube",
              "size": 1080,
              "type": "Featurette",
              "official": true,
              "published_at": "2024-05-11T19:00:31.000Z",
              "id": "664045096450048a4c204bd1"
            },
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Final Trailer",
              "key": "Kdr5oedn7q8",
              "site": "YouTube",
              "size": 1080,
              "type": "Trailer",
              "official": true,
              "published_at": "2024-04-30T16:00:26.000Z",
              "id": "663139927aecc6012472b32a"
            },
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Hope Virus",
              "key": "jY7S8TpmGoE",
              "site": "YouTube",
              "size": 1080,
              "type": "Teaser",
              "official": true,
              "published_at": "2024-04-30T04:00:21.000Z",
              "id": "66314826385202012726e08b"
            },
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Exclusive IMAX® Trailer",
              "key": "er3h_STlp-k",
              "site": "YouTube",
              "size": 1080,
              "type": "Trailer",
              "official": true,
              "published_at": "2024-04-01T13:01:36.000Z",
              "id": "660e0fc933a3760164820651"
            },
          ]
        }
      };

      final details = Details.fromJson(json);

      expect(details.runTime, '145 min');
      expect(details.genre, 'Science Fiction');
      expect(details.videoLink, 'Kdr5oedn7q8');
      expect(details.id, '653346');
    });

    test('fromJson handles missing video link gracefully', () {
      final json = {
        'runtime': 145,
        'genres': [
          [
            {"id": 878, "name": "Science Fiction"},
            {"id": 12, "name": "Adventure"},
          ],
        ],
        'videos': {'results': []},
        'id': 653346,
      };

      final details = Details.fromJson(json);

      expect(details.runTime, '145 min');
      expect(details.genre, 'Science Fiction');
      expect(details.videoLink, ''); // Handle missing video link gracefully
      expect(details.id, '653346');
    });

    test('fromJson handles missing genre gracefully', () {
      final json = {
        'runtime': 145,
        'genres': [],
        "videos": {
          "results": [
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Hidden Talent",
              "key": "ne7fE34kPug",
              "site": "YouTube",
              "size": 1080,
              "type": "Featurette",
              "official": true,
              "published_at": "2024-05-11T19:00:31.000Z",
              "id": "664045096450048a4c204bd1"
            },
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Final Trailer",
              "key": "Kdr5oedn7q8",
              "site": "YouTube",
              "size": 1080,
              "type": "Trailer",
              "official": true,
              "published_at": "2024-04-30T16:00:26.000Z",
              "id": "663139927aecc6012472b32a"
            },
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Hope Virus",
              "key": "jY7S8TpmGoE",
              "site": "YouTube",
              "size": 1080,
              "type": "Teaser",
              "official": true,
              "published_at": "2024-04-30T04:00:21.000Z",
              "id": "66314826385202012726e08b"
            },
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Exclusive IMAX® Trailer",
              "key": "er3h_STlp-k",
              "site": "YouTube",
              "size": 1080,
              "type": "Trailer",
              "official": true,
              "published_at": "2024-04-01T13:01:36.000Z",
              "id": "660e0fc933a3760164820651"
            },
          ]
        },
        'id': 653346,
      };

      final details = Details.fromJson(json);

      expect(details.runTime, '145 min');
      expect(details.genre, 'Unknown'); // Handle missing genre gracefully
      expect(details.videoLink, 'Kdr5oedn7q8');
      expect(details.id, '653346');
    });
  });
}
