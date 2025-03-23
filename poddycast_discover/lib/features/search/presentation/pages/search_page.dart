import 'dart:async';

import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/charts.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/player.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/search_results.dart';
import 'package:provider/provider.dart';

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
    final audioProvider = Provider.of<AudioFeedProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Poddycast.Discover',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        // backgroundColor: Colors.transparent,
        // elevation: null,
        // shadowColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () =>
                audioProvider.isPlaying
                    ? audioProvider.pause()
                    : audioProvider.resume(),
        child: Icon(audioProvider.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Player(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
    );
  }
}
