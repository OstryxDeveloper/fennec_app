import 'package:fennac_app/app/constants/app_enums.dart';
import 'package:fennac_app/app/constants/media_query_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/app_emojis.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/home/presentation/bloc/cubit/home_cubit.dart';
import 'package:fennac_app/widgets/prompt_audio_row.dart';
import 'package:fennac_app/reusable_widgets/animated_background_container.dart';
import 'package:fennac_app/widgets/custom_bottom_sheet.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SendPokeBottomSheet extends StatefulWidget {
  final String? image;
  final PokeType pokeType;
  final String? promptTitle;
  final String? promptAnswer;
  final String? audioPath;
  final String? audioDuration;
  final List<double>? waveformData;

  const SendPokeBottomSheet({
    super.key,
    this.image,
    required this.pokeType,
    this.promptTitle,
    this.promptAnswer,
    this.audioPath,
    this.audioDuration,
    this.waveformData,
  });

  @override
  State<SendPokeBottomSheet> createState() => _SendPokeBottomSheetState();
}

class _SendPokeBottomSheetState extends State<SendPokeBottomSheet> {
  late final TextEditingController _messageController;
  final _homeCubit = Di().sl<HomeCubit>();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _blurNotifier = ValueNotifier(false);

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

  Future<void> _sendPoke() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    Navigator.pop(context);
    await CustomBottomSheet.show(
      blurNotifier: _blurNotifier,
      context: context,
      title: 'Poke Sent!',
      description: "Let's see if they poke back.",
      buttonText: 'Done',
      icon: AnimatedBackgroundContainer(
        icon: Assets.icons.checkGreen.path,
        isPng: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder(
                    bloc: _homeCubit,
                    builder: (context, state) {
                      final profile = _homeCubit.selectedProfile;
                      return _buildPokeContent(context, profile);
                    },
                  ),
                  const CustomSizedBox(height: 32),
                  CustomLabelTextField(
                    label: 'Add a short message',
                    controller: _messageController,
                    hintText: 'Type here...',
                    filled: false,
                    maxLines: 2,
                    labelStyle: AppTextStyles.inputLabel(context),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a message to send a poke.';
                      }
                      return null;
                    },
                  ),
                  const CustomSizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorPalette.primary.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppText(
                            text:
                                'Pokes let you stand out! Send one to show interest and invite someone to chat privately.',
                            style: AppTextStyles.label(context),
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            Assets.icons.cancel.path,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomSizedBox(height: 24),
                  CustomElevatedButton(onTap: _sendPoke, text: 'Send Poke'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPokeContent(BuildContext context, dynamic profile) {
    final promptTitle =
        widget.promptTitle ??
        profile?.promptTitle ??
        'A perfect weekend for me looks like...';
    final promptAnswer =
        widget.promptAnswer ??
        profile?.promptAnswer ??
        'A morning hike, brunch with friends, and a movie marathon.';
    final audioPath = widget.audioPath ?? Assets.dummy.audio.group;
    final audioDuration = widget.audioDuration ?? '00:16';
    final displayName = profile?.name ?? profile?.firstName ?? 'User';
    final displayAge = profile?.age != null ? ', ${profile?.age}' : '';

    switch (widget.pokeType) {
      case PokeType.floating:
        return Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  widget.image ?? profile?.images?.first ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const CustomSizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  textAlign: TextAlign.center,
                  text: '$displayName$displayAge',
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

      case PokeType.audio:
        return Transform.rotate(
          angle: -0.05,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 12,
                  top: 0,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: ColorPalette.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: promptTitle,
                          style: AppTextStyles.subHeading(context),
                        ),
                        const CustomSizedBox(height: 12),
                        PromptAudioRow(
                          audioPath: audioPath,
                          duration: audioDuration,
                          waveformData: widget.waveformData,
                          height: 64,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          backgroundColor: ColorPalette.secondary,
                          playButtonColor: ColorPalette.primary,
                          waveformColor: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPalette.primary,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          AppEmojis.pointingRight,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case PokeType.text:
        return Transform.rotate(
          angle: -0.05,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 130,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorPalette.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: promptTitle,
                          style: AppTextStyles.subHeading(context),
                        ),
                        const CustomSizedBox(height: 12),
                        AppText(
                          text: promptAnswer,
                          style: AppTextStyles.h3(context),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorPalette.primary,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        AppEmojis.pointingRight,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case PokeType.image:
        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Transform.rotate(
                  angle: -0.05,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: ColorPalette.primary, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        widget.image ?? profile?.images?.first ?? '',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorPalette.primary,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    AppEmojis.pointingRight,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(context),
                  ),
                ),
              ],
            ),
            const CustomSizedBox(height: 16),
            AppText(
              textAlign: TextAlign.center,
              text: '$displayName$displayAge',
              style: AppTextStyles.h3(
                context,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        );
    }
  }
}
