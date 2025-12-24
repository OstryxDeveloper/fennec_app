import 'package:flutter/material.dart';
import 'avatar_strip.dart';

class HeroSection extends StatelessWidget {
  final String imagePath;
  final List<String> avatarPaths;

  const HeroSection({
    super.key,
    required this.imagePath,
    required this.avatarPaths,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,

      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(
            imagePath,
            height: 283,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child: Center(child: AvatarStrip(avatarPaths: avatarPaths)),
        ),
      ],
    );
  }
}
