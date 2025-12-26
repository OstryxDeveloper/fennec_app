abstract class BackgroundState {}

class BackgroundInitial extends BackgroundState {}

class BackgroundLoading extends BackgroundState {}

class BackgroundLoaded extends BackgroundState {}

class BackgroundError extends BackgroundState {}

class BackgroundUpdated extends BackgroundState {
  final double manualProgress;
  BackgroundUpdated(this.manualProgress);
}
