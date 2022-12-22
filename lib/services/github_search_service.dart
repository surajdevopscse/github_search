import 'dart:async';
import 'package:github_search/models/github_search_result.dart';
import 'package:github_search/repositories/github_search_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum APIError { rateLimitExceeded }

class GitHubSearchService {
  GitHubSearchService({required this.searchRepository}) {
    _results = _searchTerms
        .debounce((_) => TimerStream(true, const Duration(seconds: 3)))
        .switchMap((query) async* {
      yield await searchRepository.searchUser(query);
    });
  }
  final GitHubSearchRepository searchRepository;

  final _searchTerms = BehaviorSubject<String>();
  void searchUser(String username) => _searchTerms.add(username);

  late Stream<GitHubSearchResult> _results;
  Stream<GitHubSearchResult> get results => _results;

  void dispose() {
    _searchTerms.close();
  }
}

final searchServiceProvider = Provider<GitHubSearchService>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return GitHubSearchService(searchRepository: repository);
});

final searchResultsProvider =
    StreamProvider.autoDispose<GitHubSearchResult>((ref) {
  final service = ref.watch(searchServiceProvider);
  return service.results;
});
