import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/filter/presentation/bloc/cubit/filter_cubit.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupSizeBottomSheet extends StatefulWidget {
  final FilterCubit filterCubit;

  const GroupSizeBottomSheet({super.key, required this.filterCubit});

  @override
  State<GroupSizeBottomSheet> createState() => _GroupSizeBottomSheetState();
}

class _GroupSizeBottomSheetState extends State<GroupSizeBottomSheet> {
  static const int _min = 2;
  static const int _max = 5;
  late int _current;

  @override
  void initState() {
    super.initState();
    final initial = widget.filterCubit.selectedGroupSizeValue.clamp(_min, _max);
    _current = initial;
  }

  @override
  Widget build(BuildContext context) {
    final primary = ColorPalette.primary;
    final height = MediaQuery.of(context).size.height * 0.7;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorPalette.secondary, ColorPalette.black],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              AppText(
                text: 'Max number of people in a group?',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 24),
              _PeopleIcons(count: _current),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  height: 320,
                  width: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background track
                      Container(
                        width: 80,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                      ),
                      // Highlight pill - grows based on value
                      Positioned(
                        bottom: 16,
                        child: Builder(
                          builder: (context) {
                            // Calculate height based on current value
                            final progress = (_current - _min) / (_max - _min);
                            final minHeight = 120.0;
                            final maxHeight = 300.0;
                            final currentHeight =
                                minHeight + (maxHeight - minHeight) * progress;

                            return Container(
                              width: 72,
                              height: currentHeight,
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(36),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primary.withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: AppText(
                                  text: _current.toString(),
                                  style: AppTextStyles.h1Large(context)
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 48,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Touch overlay
                      Positioned.fill(
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            final box =
                                context.findRenderObject() as RenderBox?;
                            if (box == null) return;
                            final local = box.globalToLocal(
                              details.globalPosition,
                            );
                            final top = (box.size.height - 400) / 2;
                            final sliderTop = top;
                            final sliderBottom = top + 400;
                            final clampedY = local.dy.clamp(
                              sliderTop,
                              sliderBottom,
                            );
                            final t =
                                1 -
                                (clampedY - sliderTop) /
                                    (sliderBottom - sliderTop);
                            final value = (_min + t * (_max - _min))
                                .round()
                                .clamp(_min, _max);
                            setState(() {
                              _current = value;
                            });
                          },
                          onTapDown: (details) {
                            final box =
                                context.findRenderObject() as RenderBox?;
                            if (box == null) return;
                            final local = box.globalToLocal(
                              details.globalPosition,
                            );
                            final top = (box.size.height - 400) / 2;
                            final sliderTop = top;
                            final sliderBottom = top + 400;
                            final clampedY = local.dy.clamp(
                              sliderTop,
                              sliderBottom,
                            );
                            final t =
                                1 -
                                (clampedY - sliderTop) /
                                    (sliderBottom - sliderTop);
                            final value = (_min + t * (_max - _min))
                                .round()
                                .clamp(_min, _max);
                            setState(() {
                              _current = value;
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              CustomElevatedButton(
                text: 'Done',
                onTap: () {
                  widget.filterCubit.updateGroupSizeValue(_current);
                  Navigator.of(context).pop();
                },
                width: double.infinity,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeopleIcons extends StatelessWidget {
  final int count;

  const _PeopleIcons({required this.count});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: List.generate(count, (index) {
        final isFirst = index == 0;
        final isLast = index == count - 1;
        final isSecond = index == 1;
        final isSecondLast = index == count - 2;

        final size = isFirst || isLast
            ? 48.0
            : (isSecond || isSecondLast)
            ? 56.0
            : 64.0;
        return SvgPicture.asset(
          Assets.icons.user.path,
          width: size,
          height: size,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        );
      }),
    );
  }
}
