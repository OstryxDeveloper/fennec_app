import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/home/presentation/bloc/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'swipe_controller.dart';

class SwipeCard extends StatelessWidget {
  const SwipeCard({
    super.key,
    required this.controller,
    required this.child,
    required this.onSwipe,
  });

  final SwipeController controller;
  final Widget child;
  final void Function(SwipeResult) onSwipe;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = Di().sl<HomeCubit>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (d) {
        controller.onDragUpdate(d);
        cubit.updateCardPosition(controller.dragOffset.dx);
      },
      onPanEnd: (_) async {
        final result = controller.onDragEnd(size);

        onSwipe(result);
      },
      child: AnimatedBuilder(
        animation: controller.animationController,
        builder: (context, _) {
          final offset = controller.currentOffset;

          // 🔹 Tinder-like rotation
          final rotation = (offset.dx / size.width) * 0.35;

          return Transform.translate(
            offset: offset,
            child: Transform.rotate(angle: rotation, child: child),
          );
        },
      ),
    );
  }
}
