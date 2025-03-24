import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/podcast_card.dart';

class SearchResults extends StatefulWidget {
  final List<Item> items;

  const SearchResults({super.key, required this.items});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return PodcastCard(
            artworkUrl: widget.items[index].artworkUrl100 ?? '',
            feedUrl: widget.items[index].feedUrl ?? '',
            // callback: () => callFeed(widget.items[index].feedUrl ?? ''),
          );
        },
      ),
    );
  }
}
