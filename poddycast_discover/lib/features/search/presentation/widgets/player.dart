import 'dart:math';

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
  String getTitle(Episode ep) {
    return '${ep.title.substring(0, min(ep.title.length, 32))}...';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioFeedProvider>(context);
    Episode? ep = audioProvider.episode;

    return Column(
      children: [
        StreamBuilder<bool>(
          stream: audioProvider.player.playingStream,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data ?? false;
            return ListTile(
              leading:
                  audioProvider.isLoading
                      ? CircularProgressIndicator()
                      : Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              title: Text(ep != null ? getTitle(ep) : ''),
              subtitle: Text(ep?.author ?? ''),
              trailing: Icon(Icons.more_vert_outlined),
              onTap:
                  () =>
                      isPlaying
                          ? audioProvider.pause()
                          : audioProvider.resume(),
            );
          },
        ),
        StreamBuilder<Duration>(
          stream: audioProvider.player.positionStream,
          builder: (context, positionSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;
            return StreamBuilder<Duration?>(
              stream: audioProvider.player.durationStream,
              builder: (context, durationSnapshot) {
                final duration = durationSnapshot.data ?? Duration.zero;
                return Column(
                  children: [
                    Slider(
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble(),
                      value: position.inMilliseconds.toDouble().clamp(
                        0.0,
                        duration.inMilliseconds.toDouble(),
                      ),
                      onChanged: (value) {
                        audioProvider.player.seek(
                          Duration(milliseconds: value.toInt()),
                        );
                      },
                    ),
                    Text('${_formatDuration(position)} / ${_formatDuration(duration)}'),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
