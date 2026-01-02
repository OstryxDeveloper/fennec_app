import 'package:fennac_app/app/constants/app_enums.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/homelanding/presentation/bloc/state/home_landing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLandingCubit extends Cubit<HomeLandingState> {
  HomeLandingCubit() : super(HomeLandingInitial());

  final bool isGroupAudioAvailable = true;
  List<String> groupImages = [
    Assets.dummy.groupNight.path,
    Assets.dummy.groupSunset.path,
    Assets.dummy.groupSunset.path,
    Assets.dummy.groupGlasses.path,
  ];
  InvitationStatus invitationStatus = InvitationStatus.pending;

  int? selectedIndex;

  void selectGroupIndex(int? index) {
    emit(HomeLandingLoading());
    selectedIndex = index;
    emit(HomeLandingLoaded());
  }

  void selectDeclined(InvitationStatus value) {
    emit(HomeLandingLoading());
    invitationStatus = value;
    emit(HomeLandingLoaded());
  }
}
