import 'package:flutter/material.dart';
import 'package:poddycast_discover/config/theme/app_theme.dart';
import 'package:poddycast_discover/features/search/presentation/widgets/player.dart';

class MiniPlayerHolder extends StatefulWidget {
  const MiniPlayerHolder({super.key});

  @override
  State<MiniPlayerHolder> createState() => _MiniPlayerHolderState();
}

class _MiniPlayerHolderState extends State<MiniPlayerHolder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      width: 250,
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Player(),
    );
  }
}
