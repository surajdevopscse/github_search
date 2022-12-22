import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_search/models/github_search_result.dart';
import 'package:github_search/models/github_user.dart';
import 'package:github_search/services/github_search_service.dart';

class GitHubSearchDelegate extends SearchDelegate<GitHubUser?> {
  GitHubSearchDelegate(this.searchService);
  final GitHubSearchService searchService;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    searchService.searchUser(query);
    return buildMatchingSuggestions(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    searchService.searchUser(query);
    return buildMatchingSuggestions(context);
  }

  Widget buildMatchingSuggestions(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final resultsValue = ref.watch(searchResultsProvider);
        return resultsValue.when(
          data: (result) {
            return result.when(
              (users) => ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return GitHubUserSearchResultTile(
                    user: users[index],
                    onSelected: (value) => close(context, value),
                  );
                },
              ),
              error: (error) => SearchPlaceholder(title: error.message),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text(e.toString())),
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isEmpty
        ? []
        : <Widget>[
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          ];
  }
}

class GitHubUserSearchResultTile extends StatelessWidget {
  const GitHubUserSearchResultTile(
      {Key? key, required this.user, required this.onSelected})
      : super(key: key);
  final GitHubUser user;
  final ValueChanged<GitHubUser> onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(user),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 130,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.black26,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 30.0,
                left: 150.0,
                child: Text(
                  user.login,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                width: 100,
                top: 10.0,
                left: 10.0,
                bottom: 10.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    user.avatarUrl,
                    height: 150.0,
                    width: 100.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPlaceholder extends StatelessWidget {
  const SearchPlaceholder({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Text(
        title,
        style: theme.textTheme.headline5,
        textAlign: TextAlign.center,
      ),
    );
  }
}
