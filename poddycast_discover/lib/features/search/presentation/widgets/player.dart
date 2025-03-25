import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/core/util/formatter.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin {
  bool _isDragging = false; // Track if slider is being dragged
  Duration _manualPosition = Duration.zero; // Hold position during drag
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15), // Adjust speed
    )..repeat(); // Loops the animation

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.addListener(() {
        if (_scrollController.hasClients) {
          double maxScroll = _scrollController.position.maxScrollExtent;
          double scrollPosition = _animationController.value * maxScroll;
          _scrollController.jumpTo(scrollPosition);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String getTitle(Episode ep) {
    return '${ep.title.substring(0, min(ep.title.length, 32))}...';
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioFeedProvider>(context);
    Episode? ep = audioProvider.episode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<bool>(
          stream: audioProvider.player.playingStream,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data ?? false;
            return ListTile(
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  audioProvider.artowkrUrl == ''
                      ? Icon(Icons.circle, size: 32, color: Colors.blueAccent,)
                      : Card(
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          audioProvider.artowkrUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                  audioProvider.isLoading
                      ? CircularProgressIndicator()
                      : Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                ],
              ),
              title: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Text(
                  ep?.title ?? '...',
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              // subtitle: Text(ep?.author ?? ''),
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
            final position =
                _isDragging
                    ? _manualPosition
                    : (positionSnapshot.data ?? Duration.zero);
            return StreamBuilder<Duration?>(
              stream: audioProvider.player.durationStream,
              builder: (context, durationSnapshot) {
                final duration = durationSnapshot.data ?? Duration.zero;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDuration(position),
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            formatDuration(duration),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Slider(
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble(),
                      value: position.inMilliseconds.toDouble().clamp(
                        0.0,
                        duration.inMilliseconds.toDouble(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isDragging = true;
                          _manualPosition = Duration(
                            milliseconds: value.toInt(),
                          );
                        });
                      },
                      onChangeEnd: (value) async {
                        _isDragging = false;
                        await audioProvider.player.seek(
                          Duration(milliseconds: value.toInt()),
                        );
                      },
                    ),
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
