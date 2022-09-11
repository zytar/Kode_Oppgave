class FilmDetails {
  final String id;
  final String title;
  final String year;
  final String type;
  final String imdbid;
  final String tmdbid;
  final String traktid;
  final String poster;
  final String description;
  final String score;
  final String runtime;
  final String release;

  const FilmDetails({
    required this.id,
    required this.title,
    required this.year,
    required this.type,
    required this.imdbid,
    required this.tmdbid,
    required this.traktid,
    required this.poster,
    required this.description,
    required this.score,
    required this.runtime,
    required this.release,

  });

  factory FilmDetails.fromJson(Map<String, dynamic> json){
    return FilmDetails(
      id: json['id'].toString(),
      title: json['title'].toString(),
      year: json['year'].toString(),
      type: json['type'].toString(),
      imdbid: json['imdbid'].toString(),
      tmdbid: json['tmdbid'].toString(),
      traktid: json['traktid'].toString(),
      poster: json['poster'].toString(),
      description: json['description'].toString(),
      score: json['score'].toString(),
      runtime: json['runtime'].toString(),
      release: json['released'].toString(),
    );
  }
}