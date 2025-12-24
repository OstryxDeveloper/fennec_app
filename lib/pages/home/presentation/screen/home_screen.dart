import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/home/presentation/widgets/category_pill.dart';
import 'package:fennac_app/pages/home/presentation/widgets/group_gallery_widget.dart';
import 'package:fennac_app/pages/home/presentation/widgets/hero_section.dart';
import 'package:fennac_app/pages/home/presentation/widgets/home_top_bar.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _avatarPaths = [
    Assets.dummy.portrait1.path,
    Assets.dummy.portrait2.path,
    Assets.dummy.portrait3.path,
    Assets.dummy.portrait4.path,
    Assets.dummy.portrait5.path,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MovableBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomSizedBox(height: 50),
              HomeTopBar(),
              const CustomSizedBox(height: 16),
              HeroSection(
                imagePath: Assets.images.girlsGroup.path,
                avatarPaths: _avatarPaths,
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Brenda, Jack, Nancy, Jeff, Anna',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1Large(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Just a bunch of friends who love spontaneous road trips, rooftop sunsets, concerts, and pretending we're outdoorsy (until it rains).",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyRegular(
                    context,
                  ).copyWith(fontSize: 16, color: Colors.white70),
                ),
              ),

              const CustomSizedBox(height: 20),
              CategoryPill(
                iconPath: Assets.icons.navigation.path,
                label: '🧳 Travel & Adventure',
              ),
              const CustomSizedBox(height: 10),
              GroupGalleryWidget(),
              const CustomSizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
