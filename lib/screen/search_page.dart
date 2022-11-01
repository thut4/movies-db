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
  var isFocus = false;
  late FocusNode focusNode;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {
        isFocus = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: () {
                if (isFocus) {
                  _textEditingController.text = "";
                  focusNode.unfocus();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                isFocus ? "Cancel" : 'Close',
                style: const TextStyle(color: Colors.black),
              ))
        ],
        title: SizedBox(
          height: 50,
          child: TextField(
            style: const TextStyle(color: Colors.black),
            textInputAction: TextInputAction.search,
            focusNode: focusNode,
            controller: _textEditingController,
            onSubmitted: (value) {
              movieApi.getSearch(value).then((value) {
                setState(() {
                  result = value;
                });
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: "Search",
              hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: result == null
          ? const Center(child: Text("Please Search First"))
          : SearchList(list: result!),
    );
  }
}
