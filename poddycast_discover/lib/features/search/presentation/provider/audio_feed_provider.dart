import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';

class AudioFeedProvider extends ChangeNotifier {
  String _feedUrl = '';
  Episode? _episode = null;

  String get feedUrl => _feedUrl;
  Episode? get episode => _episode;

  void setFeedUrl(String value) {
    _feedUrl = value;
    notifyListeners();
  }

  void setEpiode(Episode value) {
    _episode = value;
    notifyListeners();
  }
}
