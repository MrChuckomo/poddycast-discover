import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:poddycast_discover/features/podcast/presentation/widgets/episode_list.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

class PodcastSheetContent extends StatefulWidget {
  final String feedUrl;

  const PodcastSheetContent({super.key, required this.feedUrl});

  @override
  State<PodcastSheetContent> createState() => _PodcastSheetContentState();
}

class _PodcastSheetContentState extends State<PodcastSheetContent> {
  late Future<Podcast> futurePodcastFeed;
  int episodeCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futurePodcastFeed =
        Provider.of<AudioFeedProvider>(context).futurePodcastFeed!;
    futurePodcastFeed.then((podcast) {
      setState(() {
        episodeCount = podcast.episodes.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedFlipCounter(
                duration: Duration(microseconds: 500),
                prefix: 'Episodes:',
                value: episodeCount,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/podcast');
                    },
                    icon: Icon(Icons.manage_search_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      debugPrint('mark as favorite');
                    },
                    icon: Icon(Icons.favorite_border_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
        EpisodeList(futurePodcastFeed: futurePodcastFeed),
      ],
    );
  }
}
