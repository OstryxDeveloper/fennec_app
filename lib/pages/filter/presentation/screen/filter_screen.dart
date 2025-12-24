import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/filter/presentation/bloc/cubit/filter_cubit.dart';
import 'package:fennac_app/pages/filter/presentation/bloc/state/filter_state.dart';
import 'package:fennac_app/pages/filter/presentation/widgets/filter_section.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: Stack(
        children: [
          MovableBackground(
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
                            CustomSizedBox(height: 24),
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
                                // What kind of groups section
                                AppText(
                                  text: '',
                                  style: AppTextStyles.bodyLarge(context)
                                      .copyWith(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                ),
                                CustomSizedBox(height: 12),
                                FilterSection(
                                  title:
                                      'What kind of groups are you looking for?',
                                  options: _filterCubit.categories,
                                  selectedOption: _filterCubit.selectedCategory,
                                  onOptionChanged: _filterCubit.updateCategory,
                                ),

                                // Who's in the Group section
                                AppText(
                                  text: "Who's in the Group?",
                                  style: AppTextStyles.bodyLarge(context)
                                      .copyWith(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                ),
                                CustomSizedBox(height: 12),
                                FilterSection(
                                  title: 'All genders',
                                  options: _filterCubit.genders,
                                  selectedOption: _filterCubit.selectedGender,
                                  onOptionChanged: _filterCubit.updateGender,
                                ),

                                // Choose ideal group size
                                AppText(
                                  text: 'Choose the ideal group size',
                                  style: AppTextStyles.bodyLarge(context)
                                      .copyWith(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                ),
                                CustomSizedBox(height: 12),
                                FilterSection(
                                  title: 'Max 3 people',
                                  options: _filterCubit.groupSizes,
                                  selectedOption:
                                      _filterCubit.selectedGroupSize,
                                  onOptionChanged: _filterCubit.updateGroupSize,
                                ),

                                // Distance Range
                                AppText(
                                  text: 'Distance Range',
                                  style: AppTextStyles.bodyLarge(context)
                                      .copyWith(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                ),
                                CustomSizedBox(height: 12),
                                FilterSection(
                                  title: 'Max 15 miles',
                                  options: _filterCubit.distances,
                                  selectedOption: _filterCubit.selectedDistance,
                                  onOptionChanged: _filterCubit.updateDistance,
                                ),

                                // Age Range
                                AppText(
                                  text: 'Age Range',
                                  style: AppTextStyles.bodyLarge(context)
                                      .copyWith(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                ),
                                CustomSizedBox(height: 12),
                                FilterSection(
                                  title: '25 - 35 years old',
                                  options: _filterCubit.ageRanges,
                                  selectedOption: _filterCubit.selectedAgeRange,
                                  onOptionChanged: _filterCubit.updateAgeRange,
                                ),

                                CustomSizedBox(height: 32),
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
