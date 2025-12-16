import 'package:flutter/material.dart';

import '../app/constants/media_query_constants.dart';

class CustomSizedBox extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  const CustomSizedBox({super.key, this.height, this.width, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionalHeight(context, height ?? 0),
      width: getProportionalWidth(context, width ?? 0),
      child: child,
    );
  }
}
