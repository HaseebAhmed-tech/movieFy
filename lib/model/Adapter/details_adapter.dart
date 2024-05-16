import 'package:hive_flutter/adapters.dart';
import 'package:moviely/model/details.dart';

class DetailsAdapter extends TypeAdapter<Details> {
  @override
  final int typeId = 1; // Unique type ID for Movie

  @override
  Details read(BinaryReader reader) {
    final id = reader.read();
    final runTime = reader.read();

    final genre = reader.read();
    final videoLink = reader.read();

    return Details(
      id: id,
      runTime: runTime,
      genre: genre,
      videoLink: videoLink,
    );
  }

  @override
  void write(BinaryWriter writer, Details obj) {
    writer.write(obj.id);
    writer.write(obj.runTime);
    writer.write(obj.genre);
    writer.write(obj.videoLink);
  }
}
