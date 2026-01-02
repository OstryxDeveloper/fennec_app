import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/scheduler.dart';

class AppTickerProvider implements TickerProvider {
  const AppTickerProvider();

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

class MoveAbleBackgroundCubit extends Cubit<BackgroundState> {
  late final AnimationController controller;
  late final Animation<double> animation;

  MoveAbleBackgroundCubit() : super(BackgroundInitial()) {
    controller = AnimationController(
      vsync: const AppTickerProvider(),
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
  }

  void setManualProgress(double value) {
    controller.value = value;
    emit(BackgroundUpdated(manualProgress: value));
  }
}

// states
abstract class BackgroundState {}

class BackgroundInitial extends BackgroundState {}

class BackgroundUpdated extends BackgroundState {
  final double manualProgress;
  BackgroundUpdated({required this.manualProgress});
}
