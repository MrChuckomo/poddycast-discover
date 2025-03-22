import 'dart:async';

import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  Future<void> searchItunes(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (value == '') return;

    _debounce = Timer(Duration(milliseconds: 500), () {
      debugPrint('search: $value');
      request(value);
    });
  }

  Future<void> request(String query) async {
    var iTunes = Search();
    var results = await iTunes.search(query);
    for (var item in results.items) {
      debugPrint('${item.artistName} - ${item.feedUrl}');
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: searchItunes,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
