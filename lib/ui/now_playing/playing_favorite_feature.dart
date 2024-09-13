import 'package:flutter/material.dart';

class PlayingFavoriteFeature extends StatelessWidget {
  const PlayingFavoriteFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.favorite_outline,
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}
