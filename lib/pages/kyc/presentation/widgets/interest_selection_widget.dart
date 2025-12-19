import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/state/kyc_state.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterestSelectionWidget extends StatelessWidget {
  const InterestSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = Di().sl<KycCubit>();

    return BlocBuilder<KycCubit, KycState>(
      bloc: cubit,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cubit.interestCategories.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Title
                AppText(
                  text: entry.key,
                  style: AppTextStyles.bodyLarge(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                // Interest Chips
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: entry.value.map((interest) {
                    final isSelected = cubit.selectedInterests.contains(interest);
                    final isMaxReached = cubit.selectedInterests.length >= 5 &&
                        !isSelected;

                    return InkWell(
                      onTap: () => cubit.toggleInterest(interest),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorPalette.primary
                              : ColorPalette.secondry.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? ColorPalette.primary
                                : Colors.white.withOpacity(0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: AppText(
                          text: interest,
                          style: AppTextStyles.bodyLarge(context).copyWith(
                            color: isMaxReached
                                ? Colors.white.withOpacity(0.4)
                                : Colors.white,
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

