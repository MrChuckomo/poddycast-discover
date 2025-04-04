import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

class EpisodeList extends StatefulWidget {
  final Future<Podcast> futurePodcastFeed;

  const EpisodeList({super.key, required this.futurePodcastFeed});

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<Podcast>(
        future: widget.futurePodcastFeed,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Episode? currentPlayingEpisode =
                context.read<AudioFeedProvider>().episode;
            final episodes = snapshot.data!.episodes;

            return ListView.builder(
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    episodes[index].title,
                    style: TextStyle(
                      color:
                          episodes[index].title == currentPlayingEpisode?.title
                              ? Colors.blueAccent
                              : Colors.black,
                    ),
                  ),
                  subtitle: Text(episodes[index].publicationDate.toString()),
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
    );
  }
}
