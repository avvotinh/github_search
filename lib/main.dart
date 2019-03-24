import 'package:flutter/material.dart';
import 'package:github_search/github_api.dart';
import 'package:github_search/search_screen.dart';

void main() => runApp(SearchApp());

class SearchApp extends StatefulWidget {

  SearchApp({Key key}) : super(key: key);

  @override
  _RxDartGithubSearchAppState createState() => _RxDartGithubSearchAppState();
}

class _RxDartGithubSearchAppState extends State<SearchApp> {
  GithubApi api;

  @override
  void initState() {
    api = GithubApi();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RxDart Github Search',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
      ),
      home: SearchScreen(api: api),
    );
  }
}
