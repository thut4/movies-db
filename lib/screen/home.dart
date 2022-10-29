import 'package:datshin/data/model/movie.dart';
import 'package:datshin/screen/movie_list.dart';
import 'package:datshin/screen/search_page.dart';
import 'package:flutter/material.dart';

import '../data/network/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie>? popularMovie;
  List<Movie>? nowPlayingMovies;
  loadPopular() {
    Api().getPopular().then((value) {
      setState(() {
        popularMovie = value;
      });
    });
    Api().getNowPlaying().then((value) {
      setState(() {
        nowPlayingMovies = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Datshin'),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ));
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: Column(
          children: [
            nowPlayingMovies == null
                ? const Center(child: CircularProgressIndicator())
                : MovieList(
                    list: nowPlayingMovies!,
                    title: "Now Playing",
                  ),
            popularMovie == null
                ? const Center(child: CircularProgressIndicator())
                : MovieList(
                    list: popularMovie!,
                    title: "Popular Now",
                  ),
          ],
        ));
  }
}
