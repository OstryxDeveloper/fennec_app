abstract class BackgroundState {}

class BackgroundInitial extends BackgroundState {}

class BackgroundUpdated extends BackgroundState {
  final double manualProgress;
  BackgroundUpdated(this.manualProgress);
}
