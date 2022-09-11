// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:kode_oppgave/film.dart';
import 'package:kode_oppgave/film_from_imdb.dart';
import 'package:kode_oppgave/films_api.dart';
import 'dart:async';


void main() => runApp(const FilmListApp());

class FilmListApp extends StatelessWidget {
  const FilmListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget{
  const HomePage ({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  bool search_query_filled = false;
  String search_query = "test";
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('FindAFilm');
  final searchController = TextEditingController();
  bool clicked_film = false;
  String clicked_film_imdbid = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  callback() {
    setState(() {

    });
  }

  setSearchBar(){
    setState((){
      customIcon = const Icon(Icons.cancel);
      customSearchBar = createSearchBar(setSearch, searchController);
    });
  }
  setSearch(String searchQuery) {
    setState(() {
      search_query = searchQuery;
      search_query_filled = true;
      filmExit();
    });
  }

  clearSearch() {
    setState(() {
      search_query_filled = false;
      customIcon = const Icon(Icons.search);
      customSearchBar = const Text('FindAFilm');
    });
  }


  filmExit() {
    setState(() {
      clicked_film = false;
    });
  }

  filmClick(String imdbid) {
    setState(() {
      clicked_film = true;
      clicked_film_imdbid = imdbid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: customSearchBar,
          actions: [
            createIconButton(customIcon, setSearchBar, clearSearch)
          ],
        ),
        // if search query is filled build film list else show please search message
        body: clicked_film ? showFilmDetail(clicked_film_imdbid,filmExit) : search_query_filled ? buildFilmList(search_query, filmClick) : pleaseSearch(),
        floatingActionButton: clicked_film ? exitFilm(filmExit) : null,
    );
  }
}


Widget createIconButton(Icon customIcon, Function setSearchBar, Function clearSearch) => IconButton(
      icon: customIcon,
      tooltip: 'Show search field',
      onPressed: () {
        if(customIcon.icon == Icons.search){
          setSearchBar();
        } else {
          clearSearch();
        };

      },

    );

Widget createSearchBar(Function setSearch, final searchController) => ListTile(
      leading: Icon(
        Icons.search,
        color: Colors.white,
        size: 28,
      ),
      title: TextField(
        controller: searchController,
        onSubmitted: (String searchQuery){
          setSearch(searchQuery);
        },
        enabled: true,
        decoration: InputDecoration(
          hintText: 'type in search query',
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
);

Widget exitFilm(Function filmExit) => FloatingActionButton(
  child: Icon(Icons.arrow_back),
  onPressed: (){
    filmExit();
  }
);


Widget showFilmDetail(String imdbid, Function filmExit) => FutureBuilder<FilmDetails>(
  future: FilmsApi.getFilmFromIMDB(imdbid),
  builder: (context, AsyncSnapshot snapshot){

    if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
      return filmDetailPage(
          snapshot.data.title,
          snapshot.data.year,
          snapshot.data.type,
          snapshot.data.poster,
          snapshot.data.description,
          snapshot.data.score,
          snapshot.data.release,
          filmExit);

    }else if(!snapshot.hasData && snapshot.connectionState == ConnectionState.done){
      return Text(snapshot.toString());
    }
    else {
      return CircularProgressIndicator();
    }


  },


);


Widget filmDetailPage(String title, String year, String type, String poster, String description, String score, String release, Function filmExit) => Container(
  child: ListView(
    children: [
      ListTile(
        title: (poster != "null") ? Image.network(poster) : null
        //subtitle: Text("test"),
      ),
      ListTile(
        title: Text(title,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(year),
      ),
      ListTile(
          title: Text(description)
      ),
      ListTile(
        title: Text("type: " + type)
      ),
      ListTile(
          title: Text("Release date: " + release)
      ),
      ListTile(
        title: Text("Score: "+ score+ "/100"),
      )
    ],
  ),
);

Widget pleaseSearch() => ListTile(
    title: Text("Please search for a film or a show"),
    );

Widget buildFilmList(String film, Function filmClick)  => FutureBuilder<List<Film> ?>(
    future: FilmsApi.getFilms(film),
    builder: (context, AsyncSnapshot snapshot){
      if (snapshot.hasData && snapshot.connectionState == ConnectionState.done){
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index){
            return searchResultTile(
                snapshot.data?[index].title,
                snapshot.data?[index].type,
                snapshot.data?[index].year,
                snapshot.data?[index].imdbid,
                filmClick
            );
          },
        );
      }else if(!snapshot.hasData && snapshot.connectionState == ConnectionState.done){
        return Text(snapshot.toString());
      }
      else {
        return CircularProgressIndicator();
      }
    }
);

Widget searchResultTile(String title, String type, String year, String imdbid, Function filmClick) => ListTile(
  title: Text(title),
  subtitle: Text(type + ':  ' + year),
  onTap: (){
    filmClick(imdbid);
  });

