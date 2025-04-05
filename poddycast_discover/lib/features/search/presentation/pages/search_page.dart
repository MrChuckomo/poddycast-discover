import 'dart:async';

import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/config/theme/app_theme.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/charts.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/mini_player_holder.dart';
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
      updateItems([]);
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
    updateItems(results.items);
  }

  void updateItems(List<Item> items) {
    setState(() {
      _items = items;
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
    return Theme(
      data: appTheme,
      child: Scaffold(
        appBar: AppBar(title: Text('Poddycast.Discover')),
        floatingActionButton: MiniPlayerHolder(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: [
            // Player(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: searchItunes,
                decoration: InputDecoration(
                  labelText: 'Search...',
                  border: OutlineInputBorder(),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? InkWell(
                            onTap: () {
                              _searchController.text = '';
                              updateItems([]);
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: Icon(Icons.clear),
                          )
                          : null,
                ),
              ),
            ),
            _items.isEmpty
                ? Expanded(child: Charts())
                : Expanded(
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
