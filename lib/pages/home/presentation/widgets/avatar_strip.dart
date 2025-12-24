import 'package:fennac_app/core/di_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cubit/home_cubit.dart';

class AvatarStrip extends StatefulWidget {
  final List<String> avatarPaths;

  const AvatarStrip({super.key, required this.avatarPaths});

  @override
  State<AvatarStrip> createState() => _AvatarStripState();
}

class _AvatarStripState extends State<AvatarStrip> {
  @override
  Widget build(BuildContext context) {
    const double baseSize = 48;
    const double selectedSize = 128;
    const double overlap = 40;
    const double spacing = 8;

    return BlocBuilder(
      bloc: homeCubit,
      builder: (context, state) {
        return SizedBox(
          height: selectedSize.toDouble(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalAvatars = widget.avatarPaths.length;

              double totalWidth;
              if (homeCubit.selectedIndex == null) {
                totalWidth = baseSize + (totalAvatars - 1) * overlap;
              } else {
                totalWidth = 0;
                for (int i = 0; i < totalAvatars; i++) {
                  totalWidth += (homeCubit.selectedIndex == i
                      ? selectedSize
                      : baseSize);
                  if (i != totalAvatars - 1) totalWidth += spacing;
                }
              }

              final startLeft = (constraints.maxWidth - totalWidth) / 2;

              return Stack(
                children: List.generate(totalAvatars, (index) {
                  final bool isSelected = homeCubit.selectedIndex == index;
                  final double size = isSelected ? selectedSize : baseSize;

                  double left = startLeft;
                  if (homeCubit.selectedIndex == null) {
                    left += index * overlap;
                  } else {
                    for (int i = 0; i < index; i++) {
                      left +=
                          (homeCubit.selectedIndex == i
                              ? selectedSize
                              : baseSize) +
                          spacing;
                    }
                  }

                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: left,
                    bottom: 0,
                    width: size,
                    height: size,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          homeCubit.selectGroupIndex(isSelected ? null : index);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 3),
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            widget.avatarPaths[index],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }
}

final HomeCubit homeCubit = Di().sl<HomeCubit>();
