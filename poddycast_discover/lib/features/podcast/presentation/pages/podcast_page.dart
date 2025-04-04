import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text(title),

        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
        ],
      ),
      floatingActionButton: MiniPlayerHolder(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      //! FIXME: Scaffold probably dont like Expended in body (inside EpisodeList)
      body: EpisodeList(futurePodcastFeed: futurePodcastFeed),
    );
  }
}
