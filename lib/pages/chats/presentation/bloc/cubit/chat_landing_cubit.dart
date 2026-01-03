import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/chats/presentation/bloc/state/chat_landing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatLandingCubit extends Cubit<ChatLandingState> {
  ChatLandingCubit() : super(ChatLandingInitial());

  // Store data in variables, not in state
  int selectedTabIndex = 0; // 0 for Chats, 1 for Calls

  // Mock data for groups
  List<Map<String, dynamic>> groups = [
    {
      'id': 1,
      'names': ['Brenda', 'Jack', 'Nancy', 'Jeff', 'Anna'],
      'lastMessage': 'Count me in! I\'ll bring some snacks and drinks for...',
      'time': '2h ago',
      'avatars': [
        Assets.dummy.a1.path,
        Assets.dummy.a2.path,
        Assets.dummy.a3.path,
        Assets.dummy.a4.path,
        Assets.dummy.a5.path,
      ],
    },
  ];

  // Mock data for call history
  List<Map<String, dynamic>> callHistory = [
    {
      'id': 1,
      'name': 'Nancy Garcia',
      'callType': 'Voice Call',
      'duration': '12m 5s',
      'timeAgo': '8m ago',
      'avatar': Assets.dummy.b1.path,
      'isGroup': false,
    },
    {
      'id': 2,
      'name': 'Brenda Taylor',
      'callType': 'Voice Call',
      'duration': '12m 5s',
      'timeAgo': '5d ago',
      'avatar': Assets.dummy.b2.path,
      'isGroup': false,
    },
    {
      'id': 3,
      'name': 'Anna Taylor',
      'callType': 'Voice Call',
      'duration': '12m 5s',
      'timeAgo': '16m ago',
      'avatar': Assets.dummy.b3.path,
      'isGroup': false,
    },
    {
      'id': 4,
      'names': ['Brenda', 'Jack', 'Nancy', 'Jeff', 'Anna'],
      'callType': 'Voice Call',
      'duration': '12m 5s',
      'timeAgo': '5m ago',
      'avatars': [
        Assets.dummy.c1.path,
        Assets.dummy.c2.path,
        Assets.dummy.c3.path,
        Assets.dummy.c4.path,
        Assets.dummy.c5.path,
      ],
      'isGroup': true,
    },
    {
      'id': 5,
      'name': 'Anna Taylor',
      'callType': 'Voice Call',
      'duration': '12m 5s',
      'timeAgo': '2d ago',
      'avatar': Assets.dummy.d1.path,
      'isGroup': false,
    },
    {
      'id': 6,
      'name': 'Nancy Garcia',
      'callType': 'Video Call',
      'duration': '12m 5s',
      'timeAgo': '22d ago',
      'avatar': Assets.dummy.d2.path,
      'isGroup': false,
    },
    {
      'id': 7,
      'name': 'Brenda Taylor',
      'callType': 'Voice Call',
      'duration': '12m 5s',
      'timeAgo': '21w ago',
      'avatar': Assets.dummy.d3.path,
      'isGroup': false,
    },
    {
      'id': 8,
      'names': ['Brenda', 'Jack', 'Nancy', 'Jeff', 'Anna'],
      'callType': 'Video Call',
      'duration': '12m 5s',
      'timeAgo': '17m ago',
      'avatars': [
        Assets.dummy.e1.path,
        Assets.dummy.e2.path,
        Assets.dummy.e3.path,
        Assets.dummy.e4.path,
        Assets.dummy.e5.path,
      ],
      'isGroup': true,
    },
  ];

  void selectTab(int index) {
    emit(ChatLandingLoading());
    selectedTabIndex = index;
    emit(ChatLandingLoaded());
  }
}
