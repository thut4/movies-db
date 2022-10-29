import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:datshin/component/blur.dart';
import 'package:datshin/data/model/cast.dart';
import 'package:datshin/data/model/movie.dart';
import 'package:datshin/screen/search_page.dart';
import 'package:flutter/material.dart';

import '../data/network/api_service.dart';

class DetailPage extends StatefulWidget {
  Movie movie;
  DetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var api = Api();
  List<Cast>? cast;
  @override
  void initState() {
    api.getCast(widget.movie.id).then((value) {
      setState(() {
        cast = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Stack(children: [
        BlurBackground(backdropPath: widget.movie.backdropPath),
        SingleChildScrollView(
          child: Column(
            children: [
              _movieInformation(),
              const SizedBox(
                height: 12,
              ),
              cast == null
                  ? const CircularProgressIndicator()
                  : _castInformation()
            ],
          ),
        )
      ]),
    );
  }

  _movieInformation() => Column(
        children: [
          Hero(
            tag: "${widget.movie.id}",
            child: Image(
                image: CachedNetworkImageProvider(
                    Api.imageUrl + widget.movie.posterPath)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.movie.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.movie.overview,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      );

  _castInformation() => ListView.builder(
      itemCount: cast!.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        Cast casts = cast![index];
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              casts.profilePath == null
                  ? Container()
                  : CircleAvatar(
                      radius: 32,
                      backgroundImage: CachedNetworkImageProvider(
                          Api.imageUrl + casts.profilePath!),
                    ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    casts.originalName,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    casts.character,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        );
      });
}
