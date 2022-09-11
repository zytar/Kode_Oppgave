

class Film {
  final String id;
  final String title;
  final String year;
  final String type;
  final String imdbid;
  final String tmdbid;
  final String traktid;

  const Film({
    required this.id,
    required this.title,
    required this.year,
    required this.type,
    required this.imdbid,
    required this.tmdbid,
    required this.traktid,

  });

  factory Film.fromJson(Map<String, dynamic> json){
    return Film(
      id: json['id'].toString(),
      title: json['title'].toString(),
      year: json['year'].toString(),
      type: json['type'].toString(),
      imdbid: json['imdbid'].toString(),
      tmdbid: json['tmdbid'].toString(),
      traktid: json['traktid'].toString(),
    );
  }
}