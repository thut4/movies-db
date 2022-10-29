import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/network/api_service.dart';

class BlurBackground extends StatelessWidget {
  String backdropPath;
  BlurBackground({Key? key, required this.backdropPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                Api.imageUrl + backdropPath,
              ),
              fit: BoxFit.cover)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
        ),
      ),
    );
  }
}
