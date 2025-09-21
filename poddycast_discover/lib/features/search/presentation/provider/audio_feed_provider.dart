import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast_search/podcast_search.dart';

class AudioFeedProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  String _feedUrl = '';
  String _artworkUrl = '';
  bool _isLoading = false;
  bool _isPlaying = false;
  double _speed = 1.0;
  Episode? _episode;
  Future<Podcast>? _futurePodcastFeed;

  String get feedUrl => _feedUrl;
  String get artworkUrl => _artworkUrl;
  Episode? get episode => _episode;
  bool get isLoading => _isLoading;
  bool get isPlaying => _isPlaying;
  double get speed => _speed;
  AudioPlayer get player => _player;

  AudioFeedProvider() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.black),
    );
  }

  Future<Podcast>? get futurePodcastFeed => _futurePodcastFeed;

  void fetchFeed() {
    final String sendableUrl = _feedUrl;
    _futurePodcastFeed = Isolate.run<Podcast>(() async {
      return Podcast.loadFeed(url: sendableUrl);
    });
    notifyListeners();
  }

  /// Load and play an audio file
  Future<void> playEpisode(Episode episode) async {
    if (_episode?.contentUrl == episode.contentUrl && _isPlaying) {
      return; // Prevent reloading the same episode
    }

    // Update to episode image if available
    _artworkUrl = episode.imageUrl ?? _artworkUrl;

    setEpisode(episode);
    try {
      _isLoading = true;
      _player.stop();
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(episode.contentUrl!),
          tag: MediaItem(
            id: episode.contentUrl!,
            title: episode.title,
            artist: episode.author,
            artUri: (_artworkUrl != '') ? Uri.parse(_artworkUrl) : null,
          ),
        ),
      );
      // Ensure audio session is active for iOS
      _player.play();
      _player.setSpeed(_speed);
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      _isPlaying = false;
    } finally {
      _isLoading = false;
    }
  }

  /// Pause playback
  void pause() {
    _player.pause();
    _isPlaying = false;
    notifyListeners();
  }

  /// Resume playback
  void resume() {
    _player.play();
    _isPlaying = true;
    notifyListeners();
  }

  void setSpeed(double value) {
    _speed = value;
    _player.setSpeed(_speed);
    notifyListeners();
  }

  void setArtworkUrl(String value) {
    _artworkUrl = value;
    notifyListeners();
  }

  void setFeedUrl(String value) {
    _feedUrl = value;
    notifyListeners();
  }

  void setEpisode(Episode value) {
    _episode = value;
    notifyListeners();
  }

  /// Dispose the player when not needed
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
