import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/player_speed_dial.dart';
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
  bool _showDetails = false;
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

  void _toggleDetails() {
    setState(() => _showDetails = !_showDetails);
  }

  void _togglePlayback(bool isPlaying, AudioFeedProvider provider) {
    isPlaying ? provider.pause() : provider.resume();
  }

  Widget _getArtwork(String artwork) {
    return artwork == ''
        ? Icon(Icons.circle, size: 32, color: Colors.blueAccent)
        : Card(
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            width: 50,
            height: 50,
            artwork,
            fit: BoxFit.cover,
          ),
        );
  }

  void _updateSliderDragState(double value) {
    setState(() {
      _isDragging = true;
      _manualPosition = Duration(milliseconds: value.toInt());
    });
  }

  double _getSliderValue(Duration position, Duration duration) {
    return position.inMilliseconds.toDouble().clamp(
      0.0,
      duration.inMilliseconds.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioFeedProvider>(context);
    Episode? ep = audioProvider.episode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        //* MARK: Main Elements
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: _toggleDetails,
              icon: Icon(
                _showDetails
                    ? Icons.close_fullscreen_rounded
                    : Icons.open_in_full_rounded,
              ),
            ),
            StreamBuilder<bool>(
              stream: audioProvider.player.playingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;
                return InkWell(
                  onTap: () => _togglePlayback(isPlaying, audioProvider),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _getArtwork(audioProvider.artworkUrl),
                      audioProvider.isLoading
                          ? CircularProgressIndicator()
                          : Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                    ],
                  ),
                );
              },
            ),
            PlayerSpeedDial(),
          ],
        ),

        //* MARK: Stream duration
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
                return _showDetails
                    ? Column(
                      children: [
                        ListTile(
                          dense: true,
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
                          subtitle: Row(
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
                          value: _getSliderValue(position, duration),
                          onChanged: _updateSliderDragState,
                          onChangeEnd: (value) async {
                            _isDragging = false;
                            await audioProvider.player.seek(
                              Duration(milliseconds: value.toInt()),
                            );
                          },
                        ),
                      ],
                    )
                    : const SizedBox.shrink();
              },
            );
          },
        ),
      ],
    );
  }
}
