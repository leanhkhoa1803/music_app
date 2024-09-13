import 'package:flutter/material.dart';

class PlayingSongDetails extends StatelessWidget {
  final String title;
  final String artist;
  const PlayingSongDetails({super.key, required this.title, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color)),
        const SizedBox(
          height: 8,
        ),
        Text(
          artist,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:
              Theme.of(context).textTheme.bodyMedium?.color),
        )
      ],
    );
  }
}
