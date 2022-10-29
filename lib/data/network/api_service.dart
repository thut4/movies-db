import 'package:datshin/data/model/popular.dart';
import 'package:http/http.dart' as http;

import '../model/cast.dart';
import '../model/movie.dart';
import '../model/resp_cast.dart';

class Api {
  final String _baseUrl = "https://api.themoviedb.org/3";
  static const String imageUrl = "https://image.tmdb.org/t/p/w200";
  final _apiKey = "e8ea8020653b826820f758a1b2c33b5d";

  Future<List<Movie>> getList(String url, {String param = ""}) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/$url?api_key=$_apiKey&$param"),
    );
    if (response.statusCode == 200) {
      var resp = Result.fromRawJson(response.body);
      return resp.results;
    } else {
      throw Exception('Failed');
    }
  }

  Future<List<Movie>> getPopular() async {
    return getList("/movie/popular");
  }

  Future<List<Movie>> getNowPlaying() async {
    return getList("/movie/now_playing");
  }

  Future<List<Movie>> getSearch(String name) async {
    return getList("/search/movie", param: "query=$name");
  }

  Future<List<Cast>> getCast(int movieID) async {
    var url = "/movie/$movieID/credits";
    final response =
        await http.get(Uri.parse("$_baseUrl$url?api_key=$_apiKey"));
    if (response.statusCode == 200) {
      var resp = RespCast.fromRawJson(response.body);
      return resp.cast;
    }
    else {
       throw Exception('Failed to load album');
    }
  }
}
