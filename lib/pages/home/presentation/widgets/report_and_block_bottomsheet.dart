import 'package:fennac_app/app/constants/media_query_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/reusable_widgets/animated_background_container.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class ReportAndBlockBottomSheet extends StatefulWidget {
  const ReportAndBlockBottomSheet({super.key});

  @override
  State<ReportAndBlockBottomSheet> createState() =>
      _ReportAndBlockBottomSheetState();
}

class _ReportAndBlockBottomSheetState extends State<ReportAndBlockBottomSheet> {
  String? _selectedReason;
  final TextEditingController _reasonController = TextEditingController();

  final List<String> _reportReasons = [
    'Inappropriate messages or content',
    'Fake or misleading profile(s)',
    'Harassment or bullying',
    'Spam or scam behavior',
    'Safety or privacy concern',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context) * 0.8,
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
            children: [
              AnimatedBackgroundContainer(icon: Assets.icons.slash.path),
              const CustomSizedBox(height: 24),

              AppText(
                text: 'Report & Block',
                style: AppTextStyles.h2(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const CustomSizedBox(height: 16),
              AppText(
                textAlign: TextAlign.center,
                text:
                    'Select a reason for reporting this user. They won\'t know you\'ve reported or blocked them.',
                style: AppTextStyles.body(
                  context,
                ).copyWith(color: Colors.white70),
              ),
              const CustomSizedBox(height: 16),
              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  border: Border.all(
                    color: ColorPalette.grey.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: List.generate(_reportReasons.length, (index) {
                    final reason = _reportReasons[index];
                    final isSelected = _selectedReason == reason;

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedReason = reason;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Outer ring
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      // Middle dark ring
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                        ),
                                      ),
                                      // Inner fill toggles selected state
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: !isSelected
                                              ? Colors.black.withValues(
                                                  alpha: 0.9,
                                                )
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AppText(
                                    text: reason,
                                    style: AppTextStyles.body(
                                      context,
                                    ).copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (index < _reportReasons.length - 1)
                          Divider(
                            height: 2,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                      ],
                    );
                  }),
                ),
              ),
              const CustomSizedBox(height: 28),

              CustomLabelTextField(
                label: 'Enter a Reason',
                controller: _reasonController,
                fillColor: Colors.transparent,
                labelColor: Colors.white,
                scrollController: ScrollController(),
                hintText: 'Type your reason here...',
              ),
              const CustomSizedBox(height: 28),
              CustomElevatedButton(
                text: 'Submit Report',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              const CustomSizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProhibitionIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, paint);

    canvas.drawLine(
      Offset(center.dx - radius * 0.65, center.dy - radius * 0.65),
      Offset(center.dx + radius * 0.65, center.dy + radius * 0.65),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ProhibitionIconPainter oldDelegate) => false;
}
