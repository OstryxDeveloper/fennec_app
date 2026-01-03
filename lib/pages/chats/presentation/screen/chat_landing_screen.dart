import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/chats/presentation/bloc/cubit/chat_landing_cubit.dart';
import 'package:fennac_app/pages/chats/presentation/bloc/state/chat_landing_state.dart';
import 'package:fennac_app/pages/chats/presentation/widgets/call_history_item.dart';
import 'package:fennac_app/pages/chats/presentation/widgets/chat_tab_selector.dart';
import 'package:fennac_app/pages/chats/presentation/widgets/group_list_item.dart';
import 'package:fennac_app/pages/chats/presentation/widgets/premium_card.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChatLandingScreen extends StatefulWidget {
  const ChatLandingScreen({super.key});

  @override
  State<ChatLandingScreen> createState() => _ChatLandingScreenState();
}

class _ChatLandingScreenState extends State<ChatLandingScreen> {
  final ChatLandingCubit _chatLandingCubit = Di().sl<ChatLandingCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.secondary,
      body: MovableBackground(
        backgroundType: MovableBackgroundType.dark,
        child: BlocBuilder<ChatLandingCubit, ChatLandingState>(
          bloc: _chatLandingCubit,
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  const CustomSizedBox(height: 16),
                  ChatTabSelector(
                    selectedIndex: _chatLandingCubit.selectedTabIndex,
                    onTabSelected: _chatLandingCubit.selectTab,
                  ),
                  const CustomSizedBox(height: 24),
                  Expanded(
                    child: _chatLandingCubit.selectedTabIndex == 0
                        ? _buildChatsContent()
                        : _buildCallsContent(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatsContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium card
          const PremiumCard(),
          const CustomSizedBox(height: 24),
          // Your Groups section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your Groups',
              style: AppTextStyles.h4(
                context,
              ).copyWith(color: ColorPalette.white),
            ),
          ),
          const CustomSizedBox(height: 16),
          // Group list
          ..._chatLandingCubit.groups.map((group) {
            return GroupListItem(
              names: List<String>.from(group['names']),
              lastMessage: group['lastMessage'],
              time: group['time'],
              avatars: List<String>.from(group['avatars']),
            );
          }),
          CustomSizedBox(height: MediaQuery.paddingOf(context).bottom + 30),
        ],
      ),
    );
  }

  Widget _buildCallsContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Call History section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Call History',
              style: AppTextStyles.h4(
                context,
              ).copyWith(color: ColorPalette.white),
            ),
          ),
          const CustomSizedBox(height: 16),
          // Call history list
          ..._chatLandingCubit.callHistory.map((call) {
            if (call['isGroup']) {
              return CallHistoryItem(
                names: List<String>.from(call['names']),
                callType: call['callType'],
                duration: call['duration'],
                timeAgo: call['timeAgo'],
                avatars: List<String>.from(call['avatars']),
                isGroup: true,
              );
            } else {
              return CallHistoryItem(
                name: call['name'],
                callType: call['callType'],
                duration: call['duration'],
                timeAgo: call['timeAgo'],
                avatar: call['avatar'],
                isGroup: false,
              );
            }
          }),
          const CustomSizedBox(height: 100),
        ],
      ),
    );
  }
}
