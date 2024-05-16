import 'package:hive_flutter/adapters.dart';
import 'package:moviely/model/movie.dart';

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 0; // Unique type ID for Movie

  @override
  Movie read(BinaryReader reader) {
    final title = reader.read();
    final releaseDate = reader.read();

    final rating = reader.read();
    final id = reader.read();
    final imageUrl = reader.read();
    final popularity = reader.readDouble();
    final overview = reader.read();

    return Movie(
      title: title,
      releaseDate: releaseDate,
      rating: rating,
      id: id,
      imageUrl: imageUrl,
      popularity: popularity,
      overview: overview,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer.write(obj.title);
    writer.write(obj.releaseDate);
    writer.write(obj.rating);
    writer.write(obj.id);
    writer.write(obj.imageUrl);
    writer.writeDouble(obj.popularity);
    writer.write(obj.overview);
  }
}
