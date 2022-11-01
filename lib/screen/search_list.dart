import 'package:datshin/data/model/movie.dart';
import 'package:datshin/data/network/api_service.dart';
import 'package:datshin/screen/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchList extends StatefulWidget {
  List<Movie> list;
  SearchList({Key? key, required this.list}) : super(key: key);

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        Movie movie = widget.list[index];
        return InkWell(
          onTap: () {
            Get.to(() => DetailPage(movie: movie, heroTag: "${movie.id}Search"),
                transition: Transition.fadeIn);
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                SizedBox(
                  height: 180,
                  child: Hero(
                      tag: "${movie.id}Search",
                      child: Image.network(Api.imageUrl + movie.posterPath)),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        movie.title,
                      ),
                      movie.releaseDate != null
                          ? Text("${movie.releaseDate!.year}")
                          : const Text("")
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
