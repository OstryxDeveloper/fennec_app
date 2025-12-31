import 'package:fennac_app/pages/dashboard/presentation/bloc/state/dashboard_state.dart';
import 'package:fennac_app/pages/home/presentation/screen/home_screen.dart';
import 'package:fennac_app/pages/homelanding/presentation/screen/home_landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());
  int selectedIndex = 0;
  bool shouldScrollToServices = false;

  List<Widget> screens = [
    const HomeLandingScreen(),
    const HomeScreen(),
    const HomeScreen(),
  ];

  // change current page
  void changePage(int index, Widget page) {
    emit(DashboardLoading());
    selectedIndex = index;
    screens[index] = page;
    shouldScrollToServices = false;
    emit(DashboardLoaded());
  }

  void changeIndex(int index, {bool scrollToServices = false}) {
    emit(DashboardLoading());
    selectedIndex = index;
    shouldScrollToServices = scrollToServices;
    if (index == 0 && scrollToServices) {
      screens[0] = HomeScreen(
        key: ValueKey(DateTime.now().millisecondsSinceEpoch),
      );
    }
    emit(DashboardLoaded());
  }

  void resetScrollFlag() {
    shouldScrollToServices = false;
  }

  void resetIndex() {
    emit(DashboardLoading());
    selectedIndex = 0;
    shouldScrollToServices = false;
    emit(DashboardLoaded());
  }
}
