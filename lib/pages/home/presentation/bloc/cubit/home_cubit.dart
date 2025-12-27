import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/home/presentation/bloc/state/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final bool isGroupAudioAvailable = true;
  List<String> groupImages = [
    Assets.dummy.groupNight.path,
    Assets.dummy.groupFire.path,
    Assets.dummy.groupSunset.path,
    Assets.dummy.groupGlasses.path,
    Assets.dummy.groupSelfieBeach.path,
    Assets.dummy.groupSwiming.path,
  ];

  int? selectedIndex;
  int isDeclined = 0;

  void selectGroupIndex(int? index) {
    emit(HomeLoading());
    selectedIndex = index;
    emit(HomeLoaded());
  }

  void selectDeclined(int value) {
    emit(HomeLoading());
    isDeclined = value;
    emit(HomeLoaded());
  }
}
