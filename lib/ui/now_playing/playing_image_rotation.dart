import 'package:flutter/material.dart';

class PlayingImageRotation extends StatelessWidget {
  final AnimationController imageAnimationController;
  final String image;
  const PlayingImageRotation({super.key, required this.imageAnimationController, required this.image});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta) / 2;
    return RotationTransition(
      turns:
      Tween(begin: 0.0, end: 1.0).animate(imageAnimationController),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/ITunes.jpg',
            image: image,
            width: screenWidth - delta,
            height: screenWidth - delta,
            imageErrorBuilder: (context, error, strackTrace) {
              return Image.asset(
                'assets/images/Itunes.jpg',
                width: 48,
                height: 48,
              );
            }),
      ),
    );
  }
}
