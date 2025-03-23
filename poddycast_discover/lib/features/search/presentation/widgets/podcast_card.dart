import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

class PodcastCard extends StatefulWidget {
  final String artworkUrl;
  final String feedUrl;

  const PodcastCard({
    super.key,
    required this.artworkUrl,
    required this.feedUrl,
  });

  @override
  State<PodcastCard> createState() => _PodcastCardState();
}

class _PodcastCardState extends State<PodcastCard> {
  bool _isFeedLoading = false;

  void openSheet(BuildContext context) async {
    if (widget.feedUrl == '') return;

    setState(() => _isFeedLoading = true);
    context.read<AudioFeedProvider>().setFeedUrl(widget.feedUrl);
    var feed = await Podcast.loadFeed(url: widget.feedUrl);

    showModalBottomSheet(
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 700),
      ),
      context: context,
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.manage_search_outlined),
                  Icon(Icons.favorite_border_outlined),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: feed.episodes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    isThreeLine: false,
                    title: Row(
                      children: [
                        Text(feed.episodes[index].title),
                        // Text(feed.episodes[index].publicationDate.toString()),
                      ],
                    ),
                    // subtitle: Html(data: feed.episodes[index].description),
                    subtitle: Text(
                      feed.episodes[index].publicationDate.toString(),
                    ),
                    onTap: () {
                      context.read<AudioFeedProvider>().playEpisode(
                        feed.episodes[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    ).whenComplete(() {
      setState(() => _isFeedLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color.fromARGB(255, 251, 245, 245),
      child: InkWell(
        onTap: () => openSheet(context),
        child: Stack(
          children: [
            Image.network(
              widget.artworkUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
            _isFeedLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
