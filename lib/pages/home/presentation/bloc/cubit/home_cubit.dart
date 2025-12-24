import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/home/presentation/bloc/state/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final bool isGroupAudioAvailable = true;
  List<String> groupImages = [
    Assets.dummy.groupNight.path,
    Assets.dummy.groupSunset.path,
    Assets.dummy.groupSunset.path,
    Assets.dummy.groupGlasses.path,
  ];

  int? selectedIndex;

  void selectGroupIndex(int? index) {
    emit(HomeLoading());
    selectedIndex = index;
    emit(HomeLoaded());
  }
}
