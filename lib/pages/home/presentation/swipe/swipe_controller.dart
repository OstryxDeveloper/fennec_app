import 'package:flutter/material.dart';

enum SwipeResult { left, right, none }

class SwipeController {
  SwipeController({required TickerProvider vsync, this.swipeThreshold = 100}) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );
  }

  final double swipeThreshold;
  late AnimationController animationController;
  Animation<Offset>? animation;

  Offset dragOffset = Offset.zero;
  bool isDragging = false;

  // 🔹 Finger follows card 1:1
  void onDragUpdate(DragUpdateDetails details) {
    isDragging = true;

    dragOffset = Offset(
      dragOffset.dx + details.delta.dx,
      0, // 🔒 lock vertical movement
    );
  }

  SwipeResult onDragEnd(Size screenSize) {
    isDragging = false;

    final dx = dragOffset.dx;
    final absDx = dx.abs();

    if (absDx >= swipeThreshold) {
      final isRight = dx > 0;
      _animateOut(isRight ? 1 : -1, screenSize);
      return isRight ? SwipeResult.right : SwipeResult.left;
    }

    // 🔹 Not enough → go back smoothly
    _animateBack();
    return SwipeResult.none;
  }

  void _animateOut(int direction, Size size) {
    animation =
        Tween<Offset>(
          begin: dragOffset,
          end: Offset(direction * size.width * 1.3, 0),
        ).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
        );

    animationController.forward().whenComplete(() {
      dragOffset = Offset.zero;
    });
  }

  void _animateBack() {
    animation = Tween<Offset>(begin: dragOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    animationController.forward(from: 0).whenComplete(() {
      dragOffset = Offset.zero;
    });
  }

  Offset get currentOffset {
    if (isDragging || animation == null) {
      return dragOffset;
    }
    return animation!.value;
  }

  void dispose() {
    animationController.dispose();
  }
}
