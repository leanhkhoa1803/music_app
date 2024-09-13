import 'package:flutter/material.dart';

class PlayingShareFeature extends StatelessWidget {
  const PlayingShareFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.share_outlined,
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}
