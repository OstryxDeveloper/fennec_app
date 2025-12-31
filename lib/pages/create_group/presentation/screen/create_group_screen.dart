import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/helpers/gradient_toast.dart';
import 'package:fennac_app/pages/create_group/presentation/bloc/cubit/create_group_cubit.dart';
import 'package:fennac_app/pages/create_group/presentation/widgets/create_group_content.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = Di().sl<CreateGroupCubit>();

    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        backgroundColor: ColorPalette.secondary,
        body: MovableBackground(
          child: Column(
            children: [
              // App Bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const CustomBackButton(),
                      const Spacer(),
                      AppText(
                        text: 'Create a Group',
                        style: AppTextStyles.h2(context).copyWith(fontSize: 20),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              const Expanded(child: CreateGroupContent()),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: CustomElevatedButton(
            text: 'Add Group Photos/Videos',
            onTap: () {
              VxToast.show(message: 'Coming Soon!');
            },
          ),
        ),
      ),
    );
  }
}
