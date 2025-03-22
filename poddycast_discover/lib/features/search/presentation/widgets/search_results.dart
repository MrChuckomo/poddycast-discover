import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';

class SearchResults extends StatefulWidget {
  final List<Item> items;

  const SearchResults({super.key, required this.items});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  void callFeed(String feedUrl) {
    debugPrint(feedUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color.fromARGB(255, 251, 245, 245),
          //elevation: 3,
          child: InkWell(
            onTap: () => callFeed(widget.items[index].feedUrl ?? ''),
            child: Image.network(
              widget.items[index].artworkUrl600 ?? '',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),

          //           widget.items[index].collectionName ?? '',
          //           widget.items[index].artistName ?? '',
          //           widget.items[index].feedUrl ?? '',
        );
      },
    );
  }
}
