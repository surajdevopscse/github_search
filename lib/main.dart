import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_search/features/github_search_delegate.dart';
import 'package:github_search/models/github_user.dart';
import 'package:github_search/services/github_search_service.dart';
import 'package:github_search/utils/constants.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_TITLE,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  void _showSearch(BuildContext context, WidgetRef ref) async {
    final service = ref.read(searchServiceProvider);
    final searchDelegate = GitHubSearchDelegate(service);
    final user = await showSearch<GitHubUser?>(
      context: context,
      delegate: searchDelegate,
    );
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('${Constants.SELECTED_USER} ${user.login}'),
          actions: [
            TextButton(
              child: const Text(Constants.OK),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0,
        title: TextField(
          onTap: () {
            _showSearch(context, ref);
          },
          style: const TextStyle(
            color: Colors.grey,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.arrow_back, color: Colors.grey),
            hintText: Constants.SEACRH,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: CachedNetworkImage(
              imageUrl: Constants.IMAGE_URL,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            Constants.NODATA,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
