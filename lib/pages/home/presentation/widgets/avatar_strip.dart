import 'package:flutter/material.dart';

class AvatarStrip extends StatelessWidget {
  final List<String> avatarPaths;

  const AvatarStrip({super.key, required this.avatarPaths});

  @override
  Widget build(BuildContext context) {
    const double radius = 26;
    const double overlap = 45;

    final double width = (avatarPaths.length - 1) * overlap + radius * 2;

    return SizedBox(
      width: width,
      height: radius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(avatarPaths.length, (index) {
          return Positioned(
            left: index * overlap,
            child: CircleAvatar(
              radius: radius,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: radius - 2,
                backgroundImage: AssetImage(avatarPaths[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
