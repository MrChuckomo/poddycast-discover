import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
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
  void initState() {
    super.initState();
    futurePodcastFeed = Podcast.loadFeed(url: widget.feedUrl);
    futurePodcastFeed.then((podcast) {
      setState(() => episodeCount = podcast.episodes.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.manage_search_outlined),
              Icon(Icons.favorite_border_outlined),
              AnimatedFlipCounter(
                duration: Duration(microseconds: 500),
                prefix: 'Episodes:',
                value: episodeCount,),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<Podcast>(
            future: futurePodcastFeed,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final episodes = snapshot.data!.episodes;
                return ListView.builder(
                  itemCount: episodes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(episodes[index].title),
                      subtitle: Text(
                        episodes[index].publicationDate.toString(),
                      ),
                      onTap: () {
                        context.read<AudioFeedProvider>().playEpisode(
                          episodes[index],
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ),
      ],
    );
  }
}
