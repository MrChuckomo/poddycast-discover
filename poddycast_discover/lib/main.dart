import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poddycast_discover/features/search/presentation/pages/search_page.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

void main() {
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // debugShowCheckedModeBanner: false,
      home: const SearchPage(),
    );
  }
}
