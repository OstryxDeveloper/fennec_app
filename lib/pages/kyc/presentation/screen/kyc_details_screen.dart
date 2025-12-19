import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/state/kyc_state.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/lifestyle_selection_widget.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class KycDetailsScreen extends StatelessWidget {
  const KycDetailsScreen({super.key});

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
                      CustomBackButton(),
                      CustomSizedBox(height: 24),
                      AppText(
                        text: 'Add a few details so people get a sense of you.',
                        style: AppTextStyles.h1(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      CustomSizedBox(height: 34),

                      // Short Bio
                      CustomLabelTextField(
                        label: 'Short Bio',
                        controller: _kycCubit.shortBioController,
                        hintText: 'Type here..',
                        labelColor: Colors.white,
                        filled: false,
                        maxLines: 4,
                        minLines: 3,
                      ),
                      CustomSizedBox(height: 32),

                      // Lifestyle Selection
                      AppText(
                        text: "What's your lifestyle like?",
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomSizedBox(height: 16),
                      LifestyleSelectionWidget(),
                      CustomSizedBox(height: 24),
                      CustomLabelTextField(
                        label: 'Job Title / Occupation',
                        labelStyle: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        controller: _kycCubit.jobTitleController,
                        hintText: 'What do you do?',
                        labelColor: Colors.white,
                        filled: false,
                      ),
                      CustomSizedBox(height: 16),

                      CustomLabelTextField(
                        label: 'Education / School',
                        labelStyle: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        controller: _kycCubit.educationController,
                        hintText: 'Where did you studied?',
                        labelColor: Colors.white,
                        filled: false,
                      ),
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
        child: Row(
          children: [
            Expanded(
              child: CustomOutlinedButton(
                onPressed: () {
                  AutoRouter.of(context).push(KycGalleryRoute());
                },
                text: 'Skip',
                width: double.infinity,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomElevatedButton(
                onTap: () {
                  AutoRouter.of(context).push(const KycGalleryRoute());
                },
                text: 'Continue',
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
