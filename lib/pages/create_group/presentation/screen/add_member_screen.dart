import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/create_group/presentation/bloc/cubit/create_group_cubit.dart';
import 'package:fennac_app/pages/create_group/presentation/bloc/state/create_group_state.dart';
import 'package:fennac_app/reusable_widgets/animated_background_container.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: MovableBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<CreateGroupCubit, CreateGroupState>(
            bloc: cubit,

            builder: (context, state) {
              final contacts = cubit.isSearching
                  ? cubit.searchedContacts ?? []
                  : cubit.contacts ?? [];
              final selectedMembers = cubit.selectedMembers;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SafeArea(
                    child: Row(
                      children: [
                        const CustomBackButton(),
                        const Spacer(),
                        Text('Add Member', style: AppTextStyles.h4(context)),
                        const Spacer(),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _SearchBar(),
                  const SizedBox(height: 16),
                  Flexible(
                    child: _BodyByState(
                      state: state,
                      cubit: cubit,
                      contacts: contacts,
                      selectedMembers: selectedMembers,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        return TextField(
          controller: cubit.searchController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white70,
          onChanged: (value) {
            cubit.searchContacts(value);
          },
          onSubmitted: (value) => cubit.searchContacts(value),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            hintText: 'Search by email or phone number..',
            hintStyle: const TextStyle(color: Colors.white60),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.15),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: cubit.searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: cubit.clearSearch,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Assets.icons.cancel.svg(
                        width: 14,
                        height: 14,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox(),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.24),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.36),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onDeny;
  const _PermissionCard({required this.onAllow, required this.onDeny});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 346,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: ColorPalette.black.withValues(alpha: 0.1),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedBackgroundContainer(icon: Assets.icons.union.path),
          const SizedBox(height: 24),

          Text(
            'Allow access to contacts so you can easily find your friends.',
            textAlign: TextAlign.center,
            style: AppTextStyles.h3(context),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: 'Allow Access',
                  onTap: onAllow,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomOutlinedButton(
                  text: 'Not Now',
                  onPressed: onDeny,
                  borderColor: Colors.white.withValues(alpha: 0.7),
                  textColor: Colors.white,
                  height: 52,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BodyByState extends StatelessWidget {
  final CreateGroupState state;
  final CreateGroupCubit cubit;
  final List<Contact> contacts;
  final List<Contact> selectedMembers;
  const _BodyByState({
    required this.state,
    required this.cubit,
    required this.contacts,
    required this.selectedMembers,
  });

  @override
  Widget build(BuildContext context) {
    if (state is CreateGroupInitial) {
      return _PermissionCard(
        onAllow: cubit.requestAccessAndLoadContacts,
        onDeny: cubit.denyAccess,
      );
    }
    if (state is CreateGroupPermissionDenied) {
      return const _PermissionDeniedView();
    }
    if (state is CreateGroupPermissionPermanentlyDenied) {
      return _PermissionPermanentlyDeniedView(
        onOpenSettings: cubit.openSettings,
        onRetry: cubit.requestAccessAndLoadContacts,
      );
    }
    if (state is CreateGroupLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is CreateGroupError) {
      return Center(child: Text('Error', style: AppTextStyles.body(context)));
    }

    return _ContactsList(
      contacts: contacts,
      selectedMembers: selectedMembers,
      onAddMember: (index) {
        cubit.addMember(index);
      },
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Unable to access your contacts',
          textAlign: TextAlign.center,
          style: AppTextStyles.h2(context),
        ),
        const SizedBox(height: 16),
        Text(
          "Grant access to make it easier to invite your friends from your contact list.",
          textAlign: TextAlign.center,
          style: AppTextStyles.body(context),
        ),
        const SizedBox(height: 16),
        Text(
          "We'll only use your contacts to show who's already on Fennec.",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall(context),
        ),
      ],
    );
  }
}

class _PermissionPermanentlyDeniedView extends StatelessWidget {
  final VoidCallback onOpenSettings;
  final VoidCallback onRetry;
  const _PermissionPermanentlyDeniedView({
    required this.onOpenSettings,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Unable to access your contacts',
          textAlign: TextAlign.center,
          style: AppTextStyles.h2(context),
        ),
        const SizedBox(height: 16),
        Text(
          'Contacts permission is blocked. Please enable contacts access in Settings.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body(context),
        ),
        const SizedBox(height: 16),
        Text(
          "We'll only use your contacts to show who's already on Fennec.",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall(context),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: CustomElevatedButton(
                text: 'Open Settings',
                onTap: onOpenSettings,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomOutlinedButton(
                text: 'Retry',
                onPressed: onRetry,
                borderColor: Colors.white.withValues(alpha: 0.7),
                textColor: Colors.white,
                height: 52,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactsList extends StatelessWidget {
  final List<Contact> contacts;
  final List<Contact> selectedMembers;
  final Function(int) onAddMember;
  const _ContactsList({
    required this.contacts,
    required this.selectedMembers,
    required this.onAddMember,
  });

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return Center(
        child: Text('No contacts found', style: AppTextStyles.body(context)),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: contacts.length,
      shrinkWrap: true,
      separatorBuilder: (_, __) =>
          Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
      itemBuilder: (context, index) {
        final isSelected = selectedMembers.contains(contacts[index]);
        return _ContactListItem(
          contact: contacts[index],
          isSelected: isSelected,
          onAdd: () => onAddMember(index),
        );
      },
    );
  }
}

class _ContactListItem extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final VoidCallback onAdd;
  const _ContactListItem({
    required this.contact,
    required this.isSelected,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final String name = contact.displayName;
    final String email = contact.emails.isNotEmpty
        ? contact.emails.first.address
        : "";
    final String phone = contact.phones.isNotEmpty
        ? contact.phones.first.number
        : "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white24,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: AppTextStyles.h4(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (email.isNotEmpty || phone.isNotEmpty)
                  const SizedBox(height: 4),
                if (email.isNotEmpty)
                  Text(
                    email,
                    style: AppTextStyles.bodySmall(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (phone.isNotEmpty)
                  Text(
                    phone,
                    style: AppTextStyles.bodySmall(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              height: 28,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorPalette.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                isSelected ? 'Added' : 'Add',
                style: AppTextStyles.chipLabel(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final cubit = Di().sl<CreateGroupCubit>();
