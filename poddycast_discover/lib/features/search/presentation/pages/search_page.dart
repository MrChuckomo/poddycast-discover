import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:poddycast_discover/config/theme/app_theme.dart';
import 'package:poddycast_discover/core/util/assets.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/charts.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/mini_player_holder.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Item> _items = [];
  bool _isLoading = false;

  Future<void> searchItunes(String value) async {
    setState(() => _isLoading = true);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (value.isEmpty) {
      updateItems([]);
      return;
    }

    _debounce = Timer(Duration(milliseconds: 500), () {
      debugPrint('search: $value');
      request(value);
    });
  }

  Future<void> request(String query) async {
    var iTunes = Search();
    var results = await iTunes.search(query);
    updateItems(results.items);
  }

  void updateItems(List<Item> items) {
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appTheme,
      child: Scaffold(
        // appBar: AppBar(title: Text('Poddycast.Discover')),
        // floatingActionButton: MiniPlayerHolder(),
        floatingActionButton: SearchField(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              expandedHeight: 292,
              backgroundColor: darkColor,
              flexibleSpace: FlexibleSpaceBar(
                //title: Text('Poddycast.Discover'),
                centerTitle: true,
                background: Image.asset(PodAssets.logo, fit: BoxFit.cover),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(92),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Poddycast.Discover',
                        style: TextStyle(
                          fontSize: 32,
                          shadows: [
                            Shadow(
                              color: darkColor.withValues(alpha: .3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Genres(),
                  // MiniPlayerHolder(),

                  // Section(label: 'Arts'),
                  // Section(label: 'Business'),
                  // Section(label: 'Comendy'),

                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     spacing: 12,
                  //     children: [
                  //       PodcastCard(name: 'Arts'),
                  //       PodcastCard(name: 'Business'),
                  //       PodcastCard(name: 'Comendy'),
                  //       PodcastCard(name: 'Education'),
                  //     ],
                  //   ),
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 24.0,
                  //     vertical: 8,
                  //   ),
                  //   child: TextField(
                  //     controller: _searchController,
                  //     onChanged: searchItunes,
                  //     decoration: InputDecoration(
                  //       labelText: 'Search...',
                  //       border: OutlineInputBorder(),
                  //       suffixIcon:
                  //           _searchController.text.isNotEmpty
                  //               ? InkWell(
                  //                 onTap: () {
                  //                   _searchController.text = '';
                  //                   updateItems([]);
                  //                   FocusManager.instance.primaryFocus
                  //                       ?.unfocus();
                  //                 },
                  //                 child: Icon(Icons.clear),
                  //               )
                  //               : null,
                  //     ),
                  //   ),
                  // ),
                  // _items.isEmpty
                  //     ? Expanded(child: Charts())
                  //     : Expanded(
                  //       child:
                  //           _isLoading
                  //               ? Center(child: CircularProgressIndicator())
                  //               : SearchResults(items: _items),
                  //     ),
                ],
              ),
            ),
            Charts(),
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  const Section({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          border: Border.all(color: darkColor),
        ),
        padding: EdgeInsets.all(12),
        child: Text(
          label,
          style: TextStyle(color: darkColor, fontSize: 26),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}

class PodcastCard extends StatelessWidget {
  const PodcastCard({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 212,
      width: 172,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Text(name, style: TextStyle(color: darkColor, fontSize: 24)),
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;
  List<Item> _items = [];
  bool _isLoading = false;

  Future<void> searchItunes(String value) async {
    setState(() => _isLoading = true);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (value.isEmpty) {
      updateItems([]);
      return;
    }

    _debounce = Timer(Duration(milliseconds: 500), () {
      debugPrint('search: $value');
      request(value);
    });
  }

  Future<void> request(String query) async {
    var iTunes = Search();
    var results = await iTunes.search(query);
    updateItems(results.items);
  }

  void updateItems(List<Item> items) {
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 12,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .3),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: searchItunes,
                    cursorColor: primaryColor,
                    style: TextStyle(fontSize: 26),
                    decoration: InputDecoration(
                      hintText: 'Search Podcast',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      icon: HeroIcon(HeroIcons.magnifyingGlass),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .3),
                    width: 1.5,
                  ),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: HeroIcon(HeroIcons.play),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
