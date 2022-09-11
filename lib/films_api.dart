import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:kode_oppgave/film.dart';
import 'package:kode_oppgave/film_from_imdb.dart';


class FilmsApi {
static Future<List<Film>> getFilms(searchQuery) async {
  // This uses the mdblist API to search for films.
  final response = await http.get(
    Uri.parse('https://mdblist.p.rapidapi.com/?s=' + searchQuery.toString()),
    // Send authorization headers to the backend.
    headers: {
      'X-RapidAPI-Key': 'f9f00b4076msh8e0df1796ed66e2p1cecc2jsnaa0fee07502c',
      'X-RapidAPI-Host': 'mdblist.p.rapidapi.com'
    }
  );
  return parseFilm(response.body);
}

static List<Film> parseFilm(String response){
  final parsed = convert.jsonDecode(response)['search'] as List;
  List<Film> filmer= parsed.map((json) => Film.fromJson(json)).toList();
  return filmer;
}

static Future<FilmDetails> getFilmFromIMDB(imdbid) async {
  // This uses the mdblist API to get details about a film.
  final response = await http.get(
      Uri.parse('https://mdblist.p.rapidapi.com/?i=' + imdbid.toString()),
      // Send authorization headers to the backend.
      headers: {
        'X-RapidAPI-Key': 'f9f00b4076msh8e0df1796ed66e2p1cecc2jsnaa0fee07502c',
        'X-RapidAPI-Host': 'mdblist.p.rapidapi.com'
      }
  );
  final filmDetail = convert.jsonDecode(response.body);
  return FilmDetails.fromJson(filmDetail);
}

}