import 'package:flutter/material.dart';
import 'package:github_search/search_state.dart';
import 'package:github_search/search_bloc.dart';
import 'package:github_search/github_api.dart';
import 'package:github_search/widgets/search_intro.dart';
import 'package:github_search/widgets/empty_widget.dart';
import 'package:github_search/widgets/loading_widget.dart';
import 'package:github_search/widgets/search_error_widget.dart';
import 'package:github_search/widgets/search_result_widget.dart';

class SearchScreen extends StatefulWidget {
  final GithubApi api;

  SearchScreen({Key key, this.api}) : super(key: key);

  @override
  SearchScreenState createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  SearchBloc bloc;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    bloc = SearchBloc(widget.api);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection =
            TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.state,
      initialData: SearchNoTerm(),
      builder: (_, AsyncSnapshot<SearchState> snapshot) {
        final state = snapshot.data;
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                Flex(direction: Axis.vertical, children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Github...',
                      ),
                      style: TextStyle(
                        fontSize: 36.0,
                        fontFamily: "Hind",
                        decoration: TextDecoration.none,
                      ),
                      onChanged: bloc.onTextChange.add,
                      controller: _controller,
                      focusNode: _focusNode,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        SearchIntro(visible: state is SearchNoTerm),
                        EmptyWidget(visible: state is SearchEmpty),
                        LoadingWidget(visible: state is SearchLoading),
                        SearchErrorWidget(visible: state is SearchError),
                        SearchResultWidget(
                          items:
                              state is SearchPopulated ? state.result.items : [],
                        ),
                      ],
                    ),
                  )
                ])
              ],
            ),
          ),
        );
      },
    );
  }
}
