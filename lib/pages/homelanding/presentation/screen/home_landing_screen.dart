import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/homelanding/presentation/bloc/cubit/home_landing_cubit.dart';
import 'package:fennac_app/pages/homelanding/presentation/bloc/state/home_landing_state.dart';
import 'package:fennac_app/pages/homelanding/presentation/widgets/decline_widget.dart';
import 'package:fennac_app/pages/homelanding/presentation/widgets/home_landing_banner.dart';
import 'package:fennac_app/pages/homelanding/presentation/widgets/join_widget.dart';
import 'package:fennac_app/pages/homelanding/presentation/widgets/pending_widget.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeLandingScreen extends StatefulWidget {
  const HomeLandingScreen({super.key});

  @override
  State<HomeLandingScreen> createState() => _HomeLandingScreenState();
}

class _HomeLandingScreenState extends State<HomeLandingScreen> {
  final HomeLandingCubit _homeLandingCubit = Di().sl<HomeLandingCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.secondry,
      body: MovableBackground(
        child: BlocBuilder<HomeLandingCubit, HomeLandingState>(
          bloc: _homeLandingCubit,
          builder: (context, state) {
            return Column(
              children: [
                HomeLandingBanner(),
                const CustomSizedBox(height: 24),
                if (_homeLandingCubit.invitationStatus ==
                    InvitationStatus.declined) ...[
                  DeclineWidget(),
                ] else if (_homeLandingCubit.invitationStatus ==
                    InvitationStatus.accepted) ...[
                  JoinWidget(),
                ] else ...[
                  PendingWidget(),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
