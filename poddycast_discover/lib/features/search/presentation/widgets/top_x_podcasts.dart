import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/podcast_card.dart';

class TopXPodcasts extends StatefulWidget {
  const TopXPodcasts({super.key});

  @override
  State<TopXPodcasts> createState() => _TopXPodcastsState();
}

class _TopXPodcastsState extends State<TopXPodcasts> {
  List<Item> _items = [];

  Future<void> getPodcastCharts() async {
    var iTunes = Search();
    var charts = await iTunes.charts(limit: 10);
    setState(() => _items = charts.items);
  }

  @override
  void initState() {
    getPodcastCharts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('Top 10 Podcasts'),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_items.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: PodcastCard(
                    artworkUrl: _items[index].artworkUrl600 ?? '',
                    feedUrl: _items[index].feedUrl ?? '',
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
