import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  String _currentTitle = '';
  bool _isPlaying = false;
  bool _isLoading = false;
  final _player = AudioPlayer();

  Future<void> callFeed(String feedUrl) async {
    if (feedUrl == '') return;

    setState(() => _isLoading = true);
    var feed = await Podcast.loadFeed(url: feedUrl);
    var ep = feed.episodes[0];
    play(ep);
  }

  Future<void> play(Episode ep) async {
    final duration = await _player.setUrl(ep.contentUrl ?? '');
    setState(() {
      _currentTitle = ep.title;
      _isPlaying = true;
      _isLoading = false;
    });

    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          _isLoading
              ? CircularProgressIndicator()
              : Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
      title: Text(context.watch<AudioFeedProvider>().feedUrl),
      subtitle: Text(_currentTitle),
      onTap:
          () =>
              _isPlaying
                  ? pause()
                  : callFeed(context.read<AudioFeedProvider>().feedUrl),
    );
  }
}
