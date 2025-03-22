import 'package:flutter/material.dart';

class AudioFeedProvider extends ChangeNotifier {
  String _feedUrl = '';
  // String _episode = '';

  String get feedUrl => _feedUrl;
  // String get episode => _episode;

  void setFeedUrl(String value) {
    _feedUrl = value;
    notifyListeners();
  }

  // void setEpiode(String value) {
  //   _episode = value;
  //   notifyListeners();
  // }
}
