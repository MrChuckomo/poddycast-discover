import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poddycast_discover/features/search/presentation/provider/audio_feed_provider.dart';

class PlayerSpeedDial extends StatefulWidget {
  const PlayerSpeedDial({super.key});

  @override
  State<PlayerSpeedDial> createState() => _PlayerSpeedDialState();
}

class _PlayerSpeedDialState extends State<PlayerSpeedDial> {
  List<Widget> _getMenuItems(BuildContext context) {
    var provider = context.read<AudioFeedProvider>();
    return [
      MenuItemButton(
        child: Text('2.0x'),
        onPressed: () => provider.setSpeed(2.0),
      ),
      MenuItemButton(
        child: Text('1.7x'),
        onPressed: () => provider.setSpeed(1.7),
      ),
      MenuItemButton(
        child: Text('1.5x'),
        onPressed: () => provider.setSpeed(1.5),
      ),
      MenuItemButton(
        child: Text('1.3x'),
        onPressed: () => provider.setSpeed(1.3),
      ),
      MenuItemButton(
        child: Text('1.0x'),
        onPressed: () => provider.setSpeed(1.0),
      ),
      MenuItemButton(
        child: Text('0.8x'),
        onPressed: () => provider.setSpeed(0.8),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
      menuChildren: _getMenuItems(context),
      builder: (_, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Badge(
            label: Text('${context.read<AudioFeedProvider>().speed}x'),
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.speed),
          ),
        );
      },
    );
  }
}
