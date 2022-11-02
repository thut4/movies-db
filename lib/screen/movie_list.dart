import 'package:datshin/component/poster.dart';
import 'package:datshin/data/model/movie.dart';
import 'package:datshin/screen/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/network/api_service.dart';

class MovieList extends StatefulWidget {
  List<Movie> list;
  String title;
  MovieList({Key? key, required this.list, required this.title})
      : super(key: key);

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 230,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  Movie movie = widget.list[index];
                  return InkWell(
                    onTap: () {
                      Get.to(
                          () => DetailPage(
                                movie: movie,
                                heroTag: "${movie.id}${widget.title}",
                              ),
                          transition: Transition.fadeIn);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => DetailPage(movie: movie)));
                    },
                    child: SizedBox(
                      width: 125,
                      height: 230,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 124,
                                child: Hero(
                                    tag: "${movie.id}${widget.title}",
                                    child: Poster(
                                      posterPath: movie.posterPath,
                                    ))),
                            const SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                movie.title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
