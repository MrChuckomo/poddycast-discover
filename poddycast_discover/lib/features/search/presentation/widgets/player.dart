import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioFeedProvider>(context);
    Episode? ep = audioProvider.episode;

    return ListTile(
      leading:
          audioProvider.isLoading
              ? CircularProgressIndicator()
              : Icon(audioProvider.isPlaying ? Icons.pause : Icons.play_arrow),
      title: Text(ep?.title ?? ''),
      subtitle: Text(ep?.author ?? ''),
      // trailing: Image.network(
      //   context.read<AudioFeedProvider>().episode?.imageUrl ?? '',
      // ),
      onTap:
          () =>
              audioProvider.isPlaying
                  ? audioProvider.pause()
                  : audioProvider.resume(),
    );
  }
}
