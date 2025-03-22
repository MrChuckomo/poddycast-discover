import 'dart:async';

import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Item> _items = [];
  bool _isLoading = false;

  Future<void> searchItunes(String value) async {
    setState(() => _isLoading = true);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (value.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    _debounce = Timer(Duration(milliseconds: 500), () {
      debugPrint('search: $value');
      request(value);
    });
  }

  Future<void> request(String query) async {
    var iTunes = Search();
    var results = await iTunes.search(query);
    setState(() {
      _items = results.items;
      _isLoading = false;
    });
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
      appBar: AppBar(
        title: Text('Poddycast.Discover'),
        backgroundColor: Colors.transparent,
        elevation: null,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
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
            SizedBox(height: 12),
            Expanded(
              child:
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SearchResults(items: _items),
            ),
          ],
        ),
      ),
    );
  }
}
