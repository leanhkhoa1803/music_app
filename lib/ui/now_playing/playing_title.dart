import 'package:flutter/material.dart';

class PlayingTitle extends StatelessWidget {
  final String title;
  const PlayingTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 48,
        ),
        Text(title),
        const SizedBox(
          height: 16,
        ),
        const Text("_ ___ __"),
        const SizedBox(
          height: 48,
        ),
      ],
    );
  }
}
