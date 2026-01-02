import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/constants/dummy_constants.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/filter/presentation/bloc/cubit/filter_cubit.dart';
import 'package:fennac_app/pages/filter/presentation/bloc/state/filter_state.dart';
import 'package:fennac_app/pages/filter/presentation/widgets/age_range_bottom_sheet.dart';
import 'package:fennac_app/pages/filter/presentation/widgets/filter_section.dart';
import 'package:fennac_app/pages/filter/presentation/widgets/group_size_bottom_sheet.dart';
import 'package:fennac_app/pages/filter/presentation/widgets/gender_filter_bottom_sheet.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _filterCubit = Di().sl<FilterCubit>();
  final ValueNotifier<bool> _isBlurNotifier = ValueNotifier(false);

  @override
  void dispose() {
    _isBlurNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MovableBackground(
            backgroundType: MovableBackgroundType.dark,
            child: SafeArea(
              child: BlocBuilder<FilterCubit, FilterState>(
                bloc: _filterCubit,
                builder: (context, state) {
                  return Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomBackButton(),
                                AppText(
                                  text: 'Filters',
                                  style: AppTextStyles.h1Large(context)
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(width: 48),
                              ],
                            ),
                            CustomSizedBox(height: 32),
                          ],
                        ),
                      ),
                      // Filter Options
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FilterSection(
                                  title:
                                      'What kind of groups are you looking for?',
                                  options: DummyConstants.categories,
                                  selectedOption: _filterCubit.selectedCategory,
                                  onOptionChanged: _filterCubit.updateCategory,
                                  blurNotifier: _isBlurNotifier,
                                ),
                                CustomSizedBox(height: 12),

                                FilterSection(
                                  title: "Who's in the Group?",
                                  options: DummyConstants.genders,
                                  selectedOption: _filterCubit.selectedGender,
                                  onOptionChanged: _filterCubit.updateGender,
                                  blurNotifier: _isBlurNotifier,
                                  bottomSheetBuilder: (context) =>
                                      GenderFilterBottomSheet(
                                        filterCubit: _filterCubit,
                                        blurNotifier: _isBlurNotifier,
                                      ),
                                ),
                                CustomSizedBox(height: 12),
                                FilterSection(
                                  title: 'Choose the ideal group size',
                                  options: DummyConstants.groupSizes,
                                  selectedOption:
                                      _filterCubit.selectedGroupSize,
                                  onOptionChanged: _filterCubit.updateGroupSize,
                                  blurNotifier: _isBlurNotifier,
                                  bottomSheetBuilder: (context) =>
                                      GroupSizeBottomSheet(
                                        filterCubit: _filterCubit,
                                      ),
                                ),

                                CustomSizedBox(height: 12),
                                FilterSection(
                                  title: 'Distance Range',
                                  options: DummyConstants.distances,
                                  selectedOption: _filterCubit.selectedDistance,
                                  onOptionChanged: _filterCubit.updateDistance,
                                  blurNotifier: _isBlurNotifier,
                                ),

                                CustomSizedBox(height: 12),
                                FilterSection(
                                  title: 'Age Range',
                                  options: DummyConstants.ageRanges,
                                  selectedOption: _filterCubit.selectedAgeRange,
                                  onOptionChanged: _filterCubit.updateAgeRange,
                                  blurNotifier: _isBlurNotifier,
                                  bottomSheetBuilder: (context) =>
                                      AgeRangeBottomSheet(
                                        filterCubit: _filterCubit,
                                      ),
                                ),

                                CustomSizedBox(height: 50),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isBlurNotifier,
            builder: (context, isBlurred, _) {
              return IgnorePointer(
                ignoring: !isBlurred,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isBlurred ? 1 : 0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          // vertical: 24,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomOutlinedButton(
                    text: 'Reset Filters',
                    onPressed: _filterCubit.resetFilters,
                  ),
                ),
                CustomSizedBox(width: 16),
                Expanded(
                  child: CustomElevatedButton(
                    text: 'Apply Filters',
                    onTap: () {
                      _filterCubit.applyFilters();
                      AutoRouter.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
