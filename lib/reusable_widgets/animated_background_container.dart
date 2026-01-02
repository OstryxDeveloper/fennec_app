import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class AnimatedBackgroundContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final String? icon;
  final bool? isPng;
  const AnimatedBackgroundContainer({
    super.key,
    this.height,
    this.width,
    this.icon,
    this.isPng = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100,
      height: height ?? 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset(
            Assets.animations.iconBg,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          if (isPng == false)
            SvgPicture.asset(
              icon ?? Assets.icons.vector3.path,
              height: 40,
              width: 40,
            ),
          if (isPng == true)
            Image.asset(
              icon ?? Assets.icons.vector3.path,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}
