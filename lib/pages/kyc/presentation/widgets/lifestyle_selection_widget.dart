import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/state/kyc_state.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LifestyleSelectionWidget extends StatelessWidget {
  const LifestyleSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KycCubit, KycState>(
      bloc: Di().sl<KycCubit>(),
      builder: (context, state) {
        final cubit = Di().sl<KycCubit>();

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cubit.lifestyles.map((lifestyle) {
            final isSelected = cubit.selectedLifestyles.contains(lifestyle);

            return InkWell(
              borderRadius: BorderRadius.circular(48),
              onTap: () => cubit.toggleLifestyle(lifestyle),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorPalette.primary
                      : ColorPalette.secondry,
                  borderRadius: BorderRadius.circular(48),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : ColorPalette.primary,
                    width: 1,
                  ),
                ),
                child: AppText(
                  text: lifestyle,
                  style: AppTextStyles.bodyLarge(context).copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
