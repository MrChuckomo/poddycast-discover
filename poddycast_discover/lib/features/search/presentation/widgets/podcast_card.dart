import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/podcast_sheet_content.dart';
import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

class PodcastCard extends StatefulWidget {
  final String artworkUrlPreview;
  final String artworkUrlHighRes;
  final String feedUrl;

  const PodcastCard({
    super.key,
    required this.artworkUrlPreview,
    required this.artworkUrlHighRes,
    required this.feedUrl,
  });

  @override
  State<PodcastCard> createState() => _PodcastCardState();
}

class _PodcastCardState extends State<PodcastCard> {
  bool _isFeedLoading = false;

  void openSheet(BuildContext context) {
    if (widget.feedUrl == '') return;

    setState(() => _isFeedLoading = true);
    context.read<AudioFeedProvider>().setFeedUrl(widget.feedUrl);
    context.read<AudioFeedProvider>().setArtworkUrl(widget.artworkUrlHighRes);
    context.read<AudioFeedProvider>().fetchFeed();

    // Navigator.pushNamed(context, '/podcast');
    showModalBottomSheet(
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 700),
      ),
      context: context,
      builder: (context) {
        return PodcastSheetContent(feedUrl: widget.feedUrl);
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
              widget.artworkUrlPreview,
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
