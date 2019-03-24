import 'dart:async';
import 'package:github_search/github_api.dart';
import 'package:github_search/search_state.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final Sink<String> onTextChange;
  final Stream<SearchState> state;

  factory SearchBloc(GithubApi api) {
    final onTextChange = PublishSubject<String>();

    final state = onTextChange
        .distinct()
        .debounce(const Duration(microseconds: 250))
        .switchMap((String term) => _search(term, api))
        .startWith(SearchNoTerm());

    return SearchBloc._(onTextChange, state);
  }

  SearchBloc._(this.onTextChange, this.state);

  void dispose() {
    onTextChange.close();
  }

  static Stream<SearchState> _search(String term, GithubApi api) async* {
    if (term.isEmpty) {
      yield SearchNoTerm();
    } else {
      yield SearchLoading();

      try {
        final results = await api.search(term);
        if (results.isEmpty) {
          yield SearchEmpty();
        } else {
          yield SearchPopulated(results);
        }
      } catch (e) {
        yield SearchError();
      }
    }
  }
}
