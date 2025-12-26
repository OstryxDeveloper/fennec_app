import 'package:fennac_app/pages/splash/presentation/bloc/state/background_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackgroundCubit extends Cubit<BackgroundState> {
  BackgroundCubit() : super(BackgroundInitial());

  double manualProgress = 0.0;

  int selectedIndex = 0;

  void setManualProgress(double progress) {
    manualProgress = progress;
    emit(BackgroundUpdated(manualProgress));
  }

  void selectIndex(int index) {
    emit(BackgroundLoading());
    selectedIndex = index;
    emit(BackgroundLoaded());
  }
}
