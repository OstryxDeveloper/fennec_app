import 'package:fennac_app/app/constants/dummy_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/app_emojis.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/bloc/cubit/wave_form_cubit.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/home/presentation/bloc/cubit/home_cubit.dart';
import 'package:fennac_app/pages/home/presentation/widgets/report_and_block_bottomsheet.dart';
import 'package:fennac_app/pages/home/presentation/widgets/send_poke_bottomsheet.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_prompt_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/prompt_audio_row.dart';
import 'package:fennac_app/widgets/custom_chips.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/constants/app_enums.dart';

class GroupGalleryWidget extends StatelessWidget {
  const GroupGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _homeCubit,
      builder: (context, state) {
        // Show individual profile images if a profile is selected
        if (_homeCubit.selectedProfile != null) {
          return _buildIndividualGallery(context);
        }

        // Show group gallery if no profile is selected
        return _buildGroupGallery(context);
      },
    );
  }

  Widget _buildGroupGallery(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: DummyConstants.groupImages.length,
          itemBuilder: (context, index) {
            final bool showAudio = _homeCubit.isGroupAudioAvailable;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      DummyConstants.groupImages[index],
                      // height: 408,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (showAudio && index == 0) ...[
                    const SizedBox(height: 12),
                    _GroupAudioCard(),
                  ],
                  if (index == 2) ...[
                    const SizedBox(height: 12),
                    _GroupPromptCard(),
                  ],

                  if (index == DummyConstants.groupImages.length - 1) ...[
                    const SizedBox(height: 12),
                    _GroupPromptCard(
                      prompt: "What we bring to a group trip...",
                      answer:
                          'Energy, playlists,snacks and way too many photos',
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        const CustomSizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _homeCubit.cardSwiperController.swipe(CardSwiperDirection.left);
              },
              child: Container(
                height: 66,
                width: 66,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: ColorPalette.error.withValues(alpha: .1),
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  shape: BoxShape.circle,
                  color: ColorPalette.error.withValues(alpha: .1),
                ),
                child: SvgPicture.asset(
                  Assets.icons.error.path,
                  height: 42,
                  width: 42,
                  colorFilter: ColorFilter.mode(
                    ColorPalette.error,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const CustomSizedBox(width: 32),
            GestureDetector(
              onTap: () {
                _homeCubit.cardSwiperController.swipe(
                  CardSwiperDirection.right,
                );
              },
              child: Container(
                height: 66,
                width: 66,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: ColorPalette.green.withValues(alpha: .1),
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  shape: BoxShape.circle,
                  color: ColorPalette.green.withValues(alpha: .1),
                ),
                child: Image.asset(
                  Assets.icons.checkGreen.path,
                  height: 42,
                  width: 42,
                  color: ColorPalette.green,
                ),
              ),
            ),
          ],
        ),
        const CustomSizedBox(height: 80),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const ReportAndBlockBottomSheet(),
            );
          },
          child: AppText(
            text: 'Report and block',
            style: AppTextStyles.bodyLarge(context).copyWith(),
          ),
        ),
        const CustomSizedBox(height: 80),
      ],
    );
  }

  Widget _buildIndividualGallery(BuildContext context) {
    final profile = _homeCubit.selectedProfile;
    final images = profile?.images ?? [];

    return Column(
      children: [
        if (images.isNotEmpty)
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            images[index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) => SendPokeBottomSheet(
                                  pokeType: PokeType.image,
                                  image: images[index],
                                  promptTitle: profile?.promptTitle,
                                  promptAnswer: profile?.promptAnswer,
                                ),
                              );
                            },
                            child: Container(
                              height: 34,
                              width: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ColorPalette.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(AppEmojis.pointingRight),
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (index == 1) ...[
                      const SizedBox(height: 12),
                      _GroupPromptCard(
                        prompt: profile?.promptTitle,
                        answer: profile?.promptAnswer,
                      ),
                    ],
                    if (index == 2) ...[
                      const SizedBox(height: 12),
                      _GroupAudioCard(),
                    ],
                    if (index == 3) ...[
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppText(
                          textAlign: TextAlign.left,
                          text:
                              '${_homeCubit.selectedProfile?.firstName}\'s Lifestyle',
                          style: AppTextStyles.h3(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            profile?.lifestyle
                                ?.map(
                                  (lifestyle) =>
                                      CustomChips(label: lifestyle, height: 44),
                                )
                                .toList() ??
                            [],
                      ),
                    ],
                    if (index == 4) ...[
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppText(
                          textAlign: TextAlign.left,
                          text:
                              '${_homeCubit.selectedProfile?.firstName}\'s Interests',
                          style: AppTextStyles.h3(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            profile?.lifestyle
                                ?.map(
                                  (interest) => CustomChips(
                                    label: interest,
                                    height: 44,
                                    horizontalPadding: 16,
                                    verticalPadding: 12,
                                  ),
                                )
                                .toList() ??
                            [],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        const CustomSizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _homeCubit.cardSwiperController.swipe(CardSwiperDirection.left);
              },
              child: Container(
                height: 66,
                width: 66,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: ColorPalette.error.withValues(alpha: .1),
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  shape: BoxShape.circle,
                  color: ColorPalette.error.withValues(alpha: .1),
                ),
                child: SvgPicture.asset(
                  Assets.icons.error.path,
                  height: 42,
                  width: 42,
                  colorFilter: ColorFilter.mode(
                    ColorPalette.error,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const CustomSizedBox(width: 32),
            GestureDetector(
              onTap: () {
                _homeCubit.cardSwiperController.swipe(
                  CardSwiperDirection.right,
                );
              },
              child: Container(
                height: 66,
                width: 66,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: ColorPalette.green.withValues(alpha: .1),
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  shape: BoxShape.circle,
                  color: ColorPalette.green.withValues(alpha: .1),
                ),
                child: Image.asset(
                  Assets.icons.checkGreen.path,
                  height: 42,
                  width: 42,
                  color: ColorPalette.green,
                ),
              ),
            ),
          ],
        ),
        const CustomSizedBox(height: 80),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const ReportAndBlockBottomSheet(),
            );
          },
          child: AppText(
            text: 'Report and block',
            style: AppTextStyles.bodyLarge(context).copyWith(),
          ),
        ),
        const CustomSizedBox(height: 80),
      ],
    );
  }
}

final HomeCubit _homeCubit = Di().sl<HomeCubit>();

class _GroupAudioCard extends StatelessWidget {
  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final KycPromptCubit kycPromptCubit = Di().sl<KycPromptCubit>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: .2),
            ColorPalette.black.withValues(alpha: .2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'If our group had a theme song...',
                style: AppTextStyles.bodyLarge(context),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => SendPokeBottomSheet(
                      pokeType: PokeType.audio,
                      promptTitle: 'If our group had a theme song...',
                      audioPath:
                          kycPromptCubit.recordingPath ??
                          Assets.dummy.audio.group,
                      audioDuration: kycPromptCubit.recordedDuration,
                    ),
                  );
                },
                child: Text(
                  AppEmojis.pointingRight,
                  style: AppTextStyles.bodyLarge(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          BlocBuilder(
            bloc: Di().sl<WaveformCubit>(),
            builder: (context, state) {
              return PromptAudioRow(
                audioPath:
                    kycPromptCubit.recordingPath ?? Assets.dummy.audio.group,
                duration: kycPromptCubit.recordedDuration,
                height: 64,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                backgroundColor: ColorPalette.secondary,
                playButtonColor: ColorPalette.primary,
                waveformColor: Colors.white,
                borderRadius: BorderRadius.circular(40),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GroupPromptCard extends StatelessWidget {
  final String? prompt;
  final String? answer;
  const _GroupPromptCard({this.prompt, this.answer});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: .2),
            ColorPalette.black.withValues(alpha: .2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: prompt ?? "Our group's guilty pleasure ...",
                style: AppTextStyles.subHeading(context),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => SendPokeBottomSheet(
                      pokeType: PokeType.text,
                      promptTitle: prompt,
                      promptAnswer: answer,
                    ),
                  );
                },
                child: Text(
                  AppEmojis.pointingRight,
                  style: AppTextStyles.bodyLarge(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppText(
            text: answer ?? 'Bottomless mimosas and board games 🎲',
            style: AppTextStyles.h3(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
