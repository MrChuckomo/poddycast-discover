import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:poddycast_discover/config/theme/app_theme.dart';
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
  bool isEpisodePlaying(Episode item) {
    Episode? currentPlayingEpisode = context.read<AudioFeedProvider>().episode;
    return item.title == currentPlayingEpisode?.title;
  }

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
            final episodes = snapshot.data!.episodes;
            return ListView.builder(
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(episodes[index].title),
                  subtitle: Text(episodes[index].publicationDate.toString()),
                  selected: isEpisodePlaying(episodes[index]),
                  leading: Image.network(
                    width: 25,
                    height: 25,
                    context.read<AudioFeedProvider>().artworkUrl,
                    fit: BoxFit.cover,
                  ),
                  trailing:
                      isEpisodePlaying(episodes[index])
                          ? AnimateIcon(
                            onTap: () {},
                            width: 32,
                            iconType: IconType.continueAnimation,
                            color: darkColor,
                            animateIcon: AnimateIcons.loading3,
                            // animateIcon: AnimateIcons.mute,
                            // animateIcon: AnimateIcons.pause,
                            // animateIcon: AnimateIcons.wifiSearch,
                          )
                          : null,
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
