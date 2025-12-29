import 'dart:ui';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/home/presentation/bloc/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder(
      bloc: homeCubit,
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  Image.asset(
                    imagePath,
                    height: 283,
                    opacity: AlwaysStoppedAnimation(0.8),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    opacity: homeCubit.selectedIndex != null ? 1.0 : 0.0,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0),
                      ),
                    ),
                  ),
                ],
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
      },
    );
  }
}

final HomeCubit homeCubit = Di().sl<HomeCubit>();
