import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:poddycast_discover/config/theme/app_theme.dart';
import 'package:poddycast_discover/features/podcast/presentation/pages/podcast_page.dart';
import 'package:provider/provider.dart';
import 'package:poddycast_discover/features/search/presentation/pages/search_page.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioFeedProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poddycast Discover',
      theme: appTheme,
      // debugShowCheckedModeBanner: false,
      initialRoute: '/search',
      routes: {
        '/search': (context) => SearchPage(),
        '/podcast': (context) => PodcastPage(),
      },
      // home: const SearchPage(),
    );
  }
}
