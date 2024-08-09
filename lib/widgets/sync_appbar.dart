import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class SyncAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isSyncing;
  final int syncDuration; // Sync duration in seconds
  final VoidCallback onMenuPressed;
  final VoidCallback onAccountPressed;
  final String appVersion; // Add this to pass the app version

  SyncAppBar({
    required this.isSyncing,
    required this.syncDuration,
    required this.onMenuPressed,
    required this.onAccountPressed,
    required this.appVersion, // Initialize app version
  });

  @override
  _SyncAppBarState createState() => _SyncAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SyncAppBarState extends State<SyncAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Expense Tracker'),
          Text(
            widget.appVersion, // Display the app version
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      elevation: 10,
      actions: [
        widget.isSyncing
            ? Animate(
          onComplete: (controller) => controller.repeat(),
          effects: [
            RotateEffect(
              duration: 1.seconds,
              curve: Curves.easeInOut,
            ),
          ],
          child: IconButton(
            icon: Icon(Icons.sync, color: Colors.black),
            onPressed: () {},
          ),
        )
            : IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: widget.onAccountPressed,
        ),
        if (!widget.isSyncing)
          PopupMenuButton<String>(
            onSelected: (value) {
              widget.onMenuPressed();
            },
            itemBuilder: (BuildContext context) {
              return {'Menu 1', 'Menu 2', 'Menu 3'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: Icon(Icons.more_vert),
          ),
      ],
      flexibleSpace: widget.isSyncing
          ? Shimmer.fromColors(
        baseColor: Colors.blue.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.6),
        child: Container(
          color: Colors.greenAccent,
        ),
      )
          : Container(),
    );
  }
}
