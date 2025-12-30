import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/home/data/models/group_model.dart';
import 'package:fennac_app/pages/home/presentation/bloc/cubit/home_cubit.dart';
import 'package:fennac_app/widgets/custom_chips.dart';
import 'package:flutter/material.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/home/presentation/widgets/category_pill.dart';
import 'package:fennac_app/pages/home/presentation/widgets/group_gallery_widget.dart';
import 'package:fennac_app/pages/home/presentation/widgets/hero_section.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeCardDesign extends StatelessWidget {
  final GroupModel? group;
  const HomeCardDesign({super.key, this.group});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder(
        bloc: _homeCubit,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeroSection(
                imagePath: group?.coverImage ?? '',
                avatarPaths:
                    group?.members
                        .map((member) => member.coverImage ?? "")
                        .toList() ??
                    [],
              ),
              const SizedBox(height: 32),
              if (_homeCubit.selectedProfile == null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    group?.members.map((e) => e.name ?? "").join(", ") ?? '',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h1Large(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    group?.description ?? '',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyRegular(
                      context,
                    ).copyWith(fontSize: 16, color: Colors.white70),
                  ),
                ),
                const CustomSizedBox(height: 20),
                CategoryPill(
                  iconPath: Assets.icons.navigation.path,
                  label: group?.groupTag ?? '',
                ),
              ],

              if (_homeCubit.selectedProfile != null) ...[
                // Profile name with verified badge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_homeCubit.selectedProfile?.name}, ${_homeCubit.selectedProfile?.age}',
                        style: AppTextStyles.h3(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        Assets.icons.verified.path,
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Profile tags/chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      if (_homeCubit.selectedProfile?.orientation != null &&
                          _homeCubit.selectedProfile!.orientation!.isNotEmpty)
                        CustomChips(
                          height: 28,
                          label: _homeCubit.selectedProfile!.orientation!,
                          textStyle: AppTextStyles.description(context),
                        ),
                      if (_homeCubit.selectedProfile?.pronouns != null &&
                          _homeCubit.selectedProfile!.pronouns!.isNotEmpty)
                        CustomChips(
                          height: 28,
                          label: _homeCubit.selectedProfile!.pronouns!,
                          textStyle: AppTextStyles.description(context),
                        ),
                      if (_homeCubit.selectedProfile?.location != null &&
                          _homeCubit.selectedProfile!.location!.isNotEmpty)
                        CustomChips(
                          height: 28,

                          label: '📍 ${_homeCubit.selectedProfile!.location!}',
                          textStyle: AppTextStyles.description(context),
                        ),
                      if (_homeCubit.selectedProfile?.distance != null &&
                          _homeCubit.selectedProfile!.distance!.isNotEmpty)
                        CustomChips(
                          height: 28,
                          textStyle: AppTextStyles.description(context),

                          label: _homeCubit.selectedProfile!.distance!,
                        ),
                      if (_homeCubit.selectedProfile?.education != null &&
                          _homeCubit.selectedProfile!.education!.isNotEmpty)
                        CustomChips(
                          height: 28,
                          textStyle: AppTextStyles.description(context),

                          label: _homeCubit.selectedProfile!.education!,
                        ),
                      if (_homeCubit.selectedProfile?.profession != null &&
                          _homeCubit.selectedProfile!.profession!.isNotEmpty)
                        CustomChips(
                          height: 28,
                          textStyle: AppTextStyles.description(context),

                          label: _homeCubit.selectedProfile!.profession!,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    _homeCubit.selectedProfile?.bio ?? '',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(
                      context,
                    ).copyWith(color: Colors.white70),
                  ),
                ),
              ],
              const CustomSizedBox(height: 10),
              GroupGalleryWidget(),
              const CustomSizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}

final HomeCubit _homeCubit = Di().sl<HomeCubit>();
