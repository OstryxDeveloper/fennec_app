import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/homelanding/presentation/bloc/cubit/home_landing_cubit.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLandingBanner extends StatelessWidget {
  const HomeLandingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BlocBuilder(
        bloc: _homeLandingCubit,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomSizedBox(height: 80),
              Container(
                height: 370,
                decoration: BoxDecoration(
                  color: ColorPalette.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildGroupImageWithAvatars(),
                    const CustomSizedBox(height: 54),
                    AppText(
                      text: 'Brenda,\t Nancy,\t Jeff,\t Anna',
                      style: AppTextStyles.h1(context).copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const CustomSizedBox(height: 16),
                    // Group Creation Info
                    AppText(
                      text: 'Group created by Anna Taylor 2 hours ago',
                      style: AppTextStyles.description(
                        context,
                      ).copyWith(color: ColorPalette.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const CustomSizedBox(height: 16),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupImageWithAvatars() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main Group Image
        Container(
          width: 392,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: ColorFiltered(
              colorFilter:
                  _homeLandingCubit.invitationStatus ==
                      InvitationStatus.declined
                  ? const ColorFilter.matrix(<double>[
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ])
                  : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
              child: Image.asset(
                Assets.dummy.groupSelfie.path,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Member Avatars Row at Bottom
        Positioned(
          bottom: -30,
          right: 0,
          left: 70,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in [
                Assets.dummy.a1.path,
                Assets.dummy.b1.path,
                Assets.dummy.c1.path,
                Assets.dummy.d1.path,
              ].indexed)
                Transform.translate(
                  offset: Offset(-12.0 * entry.$1, 0),
                  child: _buildMemberAvatar(entry.$2),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberAvatar(String imagePath) {
    final bool isDeclined =
        _homeLandingCubit.invitationStatus == InvitationStatus.declined;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: ColorFiltered(
          colorFilter: isDeclined
              ? const ColorFilter.matrix(<double>[
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ])
              : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

final HomeLandingCubit _homeLandingCubit = Di().sl<HomeLandingCubit>();
