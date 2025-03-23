import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast_search/podcast_search.dart';

class AudioFeedProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  String _feedUrl = '';
  bool _isLoading = false;
  bool _isPlaying = false;
  Episode? _episode;

  String get feedUrl => _feedUrl;
  Episode? get episode => _episode;
  bool get isLoading => _isLoading;
  bool get isPlaying => _isPlaying;
  AudioPlayer get player => _player;

  AudioFeedProvider() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
  }

  /// Load and play an audio file
  Future<void> playEpisode(Episode episode) async {
    if (_episode?.contentUrl == episode.contentUrl && _isPlaying) {
      return; // Prevent reloading the same episode
    }

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
            artUri:
                (episode.imageUrl != null)
                    ? Uri.parse(episode.imageUrl!)
                    : null,
          ),
        ),
      );
      // Ensure audio session is active for iOS
      _player.play();
      _player.setSpeed(1.7);
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
