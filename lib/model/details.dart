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
        genre =
            json['genres'].length > 0 ? json['genres'][0]['name'] : 'Unknown',
        videoLink = '${json['videos']['results'].firstWhere(
              (map) {
                return map['type'] == 'Trailer';
              },
              // orElse: (map) => map['type'] == 'Teaser',
              // orElse: (map) => map['Featurette'],
              orElse: () => null,
            )['key'] ?? ''}',
        id = json['id'].toString();
}
