import 'package:datshin/screen/search_list.dart';
import 'package:flutter/material.dart';


import '../data/model/movie.dart';
import '../data/network/api_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var movieApi = Api();

  List<Movie>? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(color: Colors.white),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            movieApi.getSearch(value).then((value) {
              setState(() {
                result = value;
                print(result!.length);
              });
            });
          },
          decoration: const InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: result == null
          ? const Center(child: Text("Please Search First"))
          : SearchList(list: result!),
    );
  }
}
