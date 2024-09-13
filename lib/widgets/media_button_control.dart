import 'package:flutter/material.dart';

class MediaButtonControl extends StatefulWidget {
  final void Function()? function;
  final IconData icon;
  final double? size;
  final Color? color;

  const MediaButtonControl(
      {super.key, this.function, required this.icon, this.size, this.color});

  @override
  State<StatefulWidget> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: widget.function,
        icon: Icon(widget.icon),
        iconSize: widget.size,
        color: widget.color ?? Theme.of(context).colorScheme.primary);
  }
}