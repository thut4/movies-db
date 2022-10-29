import 'package:datshin/data/model/movie.dart';
import 'package:datshin/data/network/api_service.dart';
import 'package:flutter/material.dart';

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
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                height: 180,
                child: Image.network(Api.imageUrl + movie.posterPath),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(movie.title,)
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}
