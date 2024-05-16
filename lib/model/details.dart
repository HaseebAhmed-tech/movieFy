class Details {
  const Details(
      {required this.runTime,
      required this.genre,
      required this.videoLink,
      required this.id});
  final String runTime;
  final String genre;
  final String videoLink;
  final String id;

  Details.fromJson(Map<String, dynamic> json)
      : runTime = '${json['runtime'].toString()} min',
        genre = json['genres'][0]['name'],
        videoLink = '${json['videos']['results'].firstWhere(
          (map) {
            return map['type'] == 'Trailer';
          },
          orElse: () => '',
        )['key']}',
        id = json['id'].toString();
}
