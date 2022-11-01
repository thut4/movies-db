import 'package:datshin/data/model/movie.dart';
import 'package:get/get.dart';

import '../data/network/api_service.dart';

class HomeController extends GetxController {
  RxList<Movie> popularMovies = <Movie>[].obs;
  RxList<Movie> nowPlayingMovies = <Movie>[].obs;

  loadPopular() {
    Api().getPopular().then((value) {
      popularMovies.value = value;
    });
  }

  loadNowPlaying() {
    Api().getNowPlaying().then((value) {
      nowPlayingMovies.value = value;
    });
  }
}
