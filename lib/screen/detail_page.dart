import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datshin/component/blur.dart';
import 'package:datshin/component/poster.dart';
import 'package:datshin/data/model/cast.dart';
import 'package:datshin/data/model/movie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/network/api_service.dart';

class DetailPage extends StatefulWidget {
  Movie movie;
  String heroTag = "";

  DetailPage({Key? key, required this.movie, required this.heroTag})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var api = Api();
  List<Cast>? cast;
  bool isFav = false;
  String docID = "";
  @override
  void initState() {
    api.getCast(widget.movie.id).then((value) {
      setState(() {
        cast = value;
      });
    });
    CollectionReference favs = FirebaseFirestore.instance.collection('favs');
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      favs
          .where("uid", isEqualTo: user.uid)
          .where("mid", isEqualTo: widget.movie.id)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isEmpty) {
          isFav = false;
        } else {
          isFav = true;
          docID = snapshot.docs.first.id;
        }
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (isFav) {
                    _makeUnFav();
                  } else {
                    _makeFav();
                  }
                });
              },
              icon: isFav
                  ? const Icon(
                      Icons.favorite,
                      // color: Colors.red,
                    )
                  : const Icon(Icons.favorite_outline))
        ],
      ),
      body: Stack(children: [
        widget.movie.backdropPath != null
            ? BlurBackground(backdropPath: widget.movie.backdropPath!)
            : Container(),
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

  _makeUnFav() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isFav = false;
      });
      CollectionReference favs = FirebaseFirestore.instance.collection('favs');
      favs.doc(docID).delete();
    }
  }

  _makeFav() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference favs = FirebaseFirestore.instance.collection('favs');
      favs.add({"uid": user.uid, "mid": widget.movie.id}).then((value) {
        docID = value.id;
      }).catchError((error) {
        setState(() {
          isFav = false;
        });
        print("Failed to add user :$error");
      });
    }
  }

  _movieInformation() => Column(
        children: [
          Hero(
              tag: widget.heroTag,
              child: Poster(posterPath: widget.movie.posterPath)),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      casts.originalName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      casts.character,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}
