import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/splash/presentation/bloc/cubit/background_cubit.dart';
import 'package:fennac_app/pages/splash/presentation/bloc/state/background_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fennac_app/generated/assets.gen.dart';

class MovableBackground extends StatefulWidget {
  final Widget child;
  final List<AssetGenImage> assets;

  static List<AssetGenImage> get defaultAssets => [
    Assets.images.background.bg4,
    Assets.images.background.bg5,
    Assets.images.background.bg6,
  ];

  MovableBackground({
    super.key,
    required this.child,
    List<AssetGenImage>? assets,
  }) : assets = assets ?? defaultAssets;

  @override
  State<MovableBackground> createState() => _MovableBackgroundState();
}

class _MovableBackgroundState extends State<MovableBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _rowKey = GlobalKey();
  double _rowWidth = 0.0;

  final _backgroundCubit = Di().sl<BackgroundCubit>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureRowWidth();
    });
  }

  void _measureRowWidth() {
    final RenderBox? renderBox =
        _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _rowWidth = renderBox.size.width;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _backgroundCubit,
      builder: (context, state) {
        return Builder(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            return Scaffold(
              backgroundColor: ColorPalette.black,
              body: MouseRegion(
                onHover: (event) {
                  final dx = (event.position.dx / size.width).clamp(0.0, 1.0);
                  _backgroundCubit.setManualProgress(dx);
                },
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final dx = (details.localPosition.dx / size.width).clamp(
                      0.0,
                      1.0,
                    );
                    _backgroundCubit.setManualProgress(dx);
                  },
                  child: SizedBox.expand(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        /// Background layer
                        Positioned.fill(
                          child: BlocBuilder<BackgroundCubit, BackgroundState>(
                            bloc: _backgroundCubit,
                            builder: (context, state) {
                              double manualProgress = 0.0;
                              if (state is BackgroundUpdated) {
                                manualProgress = state.manualProgress;
                              }

                              final totalWidth = _rowWidth > 0
                                  ? _rowWidth
                                  : size.width * widget.assets.length;

                              final maxOffset = totalWidth > size.width
                                  ? totalWidth - size.width
                                  : 0.0;

                              return AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  double currentProgress = _animation.value;
                                  final offset =
                                      currentProgress * maxOffset * -1;

                                  return Transform.translate(
                                    offset: Offset(offset, 0),
                                    child: child,
                                  );
                                },
                                child: OverflowBox(
                                  minWidth: 0,
                                  maxWidth: double.infinity,
                                  minHeight: size.height,
                                  maxHeight: size.height,
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    key: _rowKey,
                                    mainAxisSize: MainAxisSize.min,
                                    children: widget.assets.map((asset) {
                                      return SizedBox(
                                        height: size.height,
                                        child: asset.image(
                                          fit: BoxFit.fitHeight,
                                          height: size.height,
                                          alignment: Alignment.center,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        /// Child content on top
                        widget.child,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
