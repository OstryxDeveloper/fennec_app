import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/dashboard/presentation/bloc/cubit/dashboard_cubit.dart';
import 'package:fennac_app/utils/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardCubit _dashboardCubit = Di().sl<DashboardCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder(
        bloc: _dashboardCubit,
        builder: (context, state) {
          return Stack(
            children: [
              IndexedStack(
                index: _dashboardCubit.selectedIndex,
                children: _dashboardCubit.screens,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: CustomBottomNavigationBar(
                    items: [
                      BottomNavItem(iconPath: Assets.icons.home.path),

                      BottomNavItem(iconPath: Assets.icons.messageCircle.path),
                      BottomNavItem(iconPath: Assets.icons.user.path),
                    ],
                    currentIndex: _dashboardCubit.selectedIndex,
                    onTap: _dashboardCubit.changeIndex,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
