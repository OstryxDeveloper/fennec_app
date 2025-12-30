import 'package:fennac_app/app/constants/media_query_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/home/presentation/bloc/cubit/home_cubit.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SendPokeBottomSheet extends StatefulWidget {
  const SendPokeBottomSheet({super.key});

  @override
  State<SendPokeBottomSheet> createState() => _SendPokeBottomSheetState();
}

class _SendPokeBottomSheetState extends State<SendPokeBottomSheet> {
  late final TextEditingController _messageController;
  final _homeCubit = Di().sl<HomeCubit>();

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendPoke() {
    // Validation: at least one character or message is optional
    if (_messageController.text.trim().isNotEmpty) {
      // Send poke with message
      debugPrint('Sending poke with message: ${_messageController.text}');
    } else {
      // Send poke without message
      debugPrint('Sending poke without message');
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context),
      height: 583,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF16003F), ColorPalette.black],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Section
              BlocBuilder(
                bloc: _homeCubit,
                builder: (context, state) {
                  final profile = _homeCubit.selectedProfile;
                  return Column(
                    children: [
                      // Profile Image with Status Icon
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                              child: Image.asset(
                                profile?.images?.first ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette.primary,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: SvgPicture.asset(
                              Assets.icons.fork.path,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                      const CustomSizedBox(height: 16),
                      // Name and Age with Verified Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            textAlign: TextAlign.center,
                            text: '${profile?.name}, ${profile?.age}',
                            style: AppTextStyles.h3(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          SvgPicture.asset(
                            Assets.icons.verified.path,
                            height: 24,
                            width: 24,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const CustomSizedBox(height: 24),

              // Message Section Label
              CustomLabelTextField(
                label: 'Add a short message',
                controller: _messageController,

                hintText: 'Type here...',
              ),

              const CustomSizedBox(height: 24),

              // Info Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppText(
                        text:
                            'Pokes let you stand out! Send one to show interest and invite someone to chat privately.',
                        style: AppTextStyles.bodyRegular(context).copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const CustomSizedBox(height: 24),

              // Send Poke Button
              CustomElevatedButton(onTap: _sendPoke, text: 'Send Poke'),
            ],
          ),
        ),
      ),
    );
  }
}
