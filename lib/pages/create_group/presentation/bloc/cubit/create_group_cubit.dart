import 'dart:developer';

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fennac_app/widgets/gradient_toast.dart';

import '../state/create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  CreateGroupCubit() : super(CreateGroupInitial());

  List<Contact>? contacts;
  List<Contact>? searchedContacts;
  bool isSearching = false;
  final searchController = TextEditingController();
  final List<Contact> selectedMembers = [];

  Future<void> requestAccessAndLoadContacts() async {
    emit(CreateGroupLoading());

    try {
      final status = await Permission.contacts.status;

      if (status.isGranted) {
        contacts = await FastContacts.getAllContacts();
        emit(CreateGroupLoaded());
        return;
      }

      if (status.isDenied) {
        final result = await Permission.contacts.request();

        if (result.isGranted) {
          contacts = await FastContacts.getAllContacts();
          emit(CreateGroupLoaded());
        } else if (result.isPermanentlyDenied) {
          emit(CreateGroupPermissionPermanentlyDenied());
        } else {
          emit(CreateGroupPermissionDenied());
        }
        return;
      }

      if (status.isPermanentlyDenied) {
        emit(CreateGroupPermissionPermanentlyDenied());
      }
    } catch (e, s) {
      log('Contacts access failed', error: e, stackTrace: s);
      emit(CreateGroupError());
    }
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }

  void denyAccess() {
    emit(CreateGroupPermissionDenied());
  }

  void addMember(int contactIndex) {
    emit(CreateGroupLoading());

    if (selectedMembers.length >= 4) {
      VxToast.show(message: 'You can add up to 4 members in a group.');
      emit(CreateGroupLoaded());
      return;
    }

    if (contacts != null &&
        contactIndex >= 0 &&
        contactIndex < contacts!.length) {
      final contact = contacts![contactIndex];
      if (!selectedMembers.contains(contact)) {
        selectedMembers.add(contact);
        emit(CreateGroupLoaded());
        log('CreateGroupCubit: added member ${contact.displayName}');
      }
    }
  }

  void removeMember(int memberIndex) {
    emit(CreateGroupLoading());
    if (memberIndex >= 0 && memberIndex < selectedMembers.length) {
      final removed = selectedMembers.removeAt(memberIndex);
      emit(CreateGroupLoaded());
      log('CreateGroupCubit: removed member ${removed.displayName}');
    }
  }

  void searchContacts(String query) {
    emit(CreateGroupLoading());

    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }
    isSearching = true;
    searchedContacts = contacts?.where((contact) {
      final name = contact.displayName.toLowerCase();
      final q = query.toLowerCase().trim();

      final phoneMatch = contact.phones.any(
        (phone) =>
            phone.number.replaceAll(' ', '').contains(q.replaceAll(' ', '')),
      );

      return name.contains(q) || phoneMatch;
    }).toList();

    emit(CreateGroupLoaded());
  }

  void clearSearch() {
    emit(CreateGroupLoading());
    searchController.clear();
    searchedContacts = null;
    isSearching = false;
    emit(CreateGroupLoaded());
  }
}
