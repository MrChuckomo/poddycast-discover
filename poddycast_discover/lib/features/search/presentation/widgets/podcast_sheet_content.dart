import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

class PodcastSheetContent extends StatefulWidget {
  final String feedUrl;

  const PodcastSheetContent({super.key, required this.feedUrl});

  @override
  State<PodcastSheetContent> createState() => _PodcastSheetContentState();
}

class _PodcastSheetContentState extends State<PodcastSheetContent> {
  Future<Podcast> _fetchFeed() async {
    return await Podcast.loadFeed(url: widget.feedUrl);
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
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<Podcast>(
            future: _fetchFeed(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('An Error occured during loading the feed.'),
                );
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
