import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/state/kyc_state.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/interest_selection_widget.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class KycMatchScreen extends StatelessWidget {
  const KycMatchScreen({super.key});

  KycCubit get _kycCubit => Di().sl<KycCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: MovableBackground(
        child: SafeArea(
          child: BlocBuilder<KycCubit, KycState>(
            bloc: _kycCubit,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSizedBox(height: 20),
                      CustomBackButton(),
                      CustomSizedBox(height: 32),
                      AppText(
                        text: 'Choose what you love so we can match your vibe.',
                        style: AppTextStyles.h1(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      CustomSizedBox(height: 8),
                      AppText(
                        text: 'You can select up to 5 interests.',
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      CustomSizedBox(height: 32),

                      InterestSelectionWidget(),
                      CustomSizedBox(height: 40),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomOutlinedButton(
                    onPressed: () {
                      AutoRouter.of(context).push(KycPromptRoute());
                    },
                    text: 'Skip',
                    width: double.infinity,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomElevatedButton(
                    onTap: () {
                      AutoRouter.of(context).push(KycPromptRoute());
                    },
                    text: 'Continue',
                    width: double.infinity,
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
