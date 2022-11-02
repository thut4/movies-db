import 'package:datshin/controller/home_controller.dart';
import 'package:datshin/screen/movie_list.dart';
import 'package:datshin/screen/search_page.dart';
import 'package:datshin/screen/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Movie>? popularMovie;
  // List<Movie>? nowPlayingMovies;
  final HomeController controller = Get.put(HomeController());
  // loadPopular() {
  //   Api().getPopular().then((value) {
  //     setState(() {
  //       popularMovie = value;
  //     });
  //   });
  //   Api().getNowPlaying().then((value) {
  //     setState(() {
  //       nowPlayingMovies = value;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // loadPopular();
    controller.loadPopular();
    controller.loadNowPlaying();
  }

  Widget _popularList() => controller.popularMovies.isEmpty
      ? const CircularProgressIndicator()
      : MovieList(list: controller.popularMovies, title: "Popular");

  Widget _nowPlayingList() => controller.popularMovies.isEmpty
      ? const CircularProgressIndicator()
      : MovieList(list: controller.nowPlayingMovies, title: "Now Playing");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Datshin'),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.off(() => SignIn());
              },
              icon: const Icon(Icons.logout_rounded)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage(),
                          fullscreenDialog: true));
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: Obx(() {
          return Column(
            children: [_nowPlayingList(), _popularList()],
          );
        }));
  }
}
