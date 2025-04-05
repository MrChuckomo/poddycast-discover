import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/config/theme/app_theme.dart';
import 'package:poddycast_discover/features/podcast/presentation/widgets/episode_list.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/mini_player_holder.dart';
import 'package:provider/provider.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key});

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  late Future<Podcast> futurePodcastFeed;
  int episodeCount = 0;
  String title = 'Poddycast.Discover';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futurePodcastFeed =
        Provider.of<AudioFeedProvider>(context).futurePodcastFeed!;
    futurePodcastFeed.then((podcast) {
      setState(() {
        title = podcast.title ?? 'Poddycast.Discover';
        episodeCount = podcast.episodes.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appTheme,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
          ],
        ),
        floatingActionButton: MiniPlayerHolder(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        //! FIXME: Scaffold probably dont like Expended in body (inside EpisodeList)
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: primaryColor,
                  width: double.infinity,
                  height: 135,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Image.network(
                        width: 105,
                        height: 105,
                        context.read<AudioFeedProvider>().artworkUrl,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: TextStyle(color: darkColor)),
                          AnimatedFlipCounter(
                            prefix: 'Episodes: ',
                            value: episodeCount,
                            curve: Curves.easeOut,
                            textStyle: TextStyle(color: darkColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            EpisodeList(futurePodcastFeed: futurePodcastFeed),
          ],
        ),
        // TODO: add a quick filter for the list
        // TODO: Show the artwork in a nice way
      ),
    );
  }
}
