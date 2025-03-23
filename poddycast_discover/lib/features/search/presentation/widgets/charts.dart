import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/top_x_podcasts.dart';

class Charts extends StatefulWidget {
  const Charts({super.key});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  final List<Widget> categoryRows = [
    Genres(),
    TopXPodcasts(),
    TopXPodcasts(genre: 'True Crime'),
    TopXPodcasts(genre: 'Technology'),
    TopXPodcasts(genre: 'Comedy'),
    TopXPodcasts(genre: 'Sports'),
    TopXPodcasts(genre: 'Music'),
    TopXPodcasts(genre: 'Business'),
    TopXPodcasts(genre: 'Education'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categoryRows.length,
      itemBuilder: (context, index) {
        return categoryRows[index];
      },
    );
  }
}

class Genres extends StatelessWidget {
  const Genres({super.key});

  List<String> get genres {
    var iTunes = Search();
    return iTunes.genres().where((item) => item.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(genres.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 4.0),
            child: Chip(
              backgroundColor: Colors.blueAccent.withAlpha(32),
              label: Text(genres[index]),
            ),
          );
        }),
      ),
    );
  }
}
