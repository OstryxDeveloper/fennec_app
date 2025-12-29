import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/create_group/presentation/bloc/cubit/create_group_cubit.dart';
import 'package:fennac_app/pages/create_group/presentation/bloc/state/create_group_state.dart';
import 'package:fennac_app/pages/create_group/presentation/widgets/interest_chip.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateGroupContent extends StatefulWidget {
  const CreateGroupContent({super.key});

  @override
  State<CreateGroupContent> createState() => _CreateGroupContentState();
}

class _CreateGroupContentState extends State<CreateGroupContent> {
  final Set<String> _selectedInterests = {};
  final TextEditingController _bioController = TextEditingController();
  final cubit = Di().sl<CreateGroupCubit>();

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: AppText(
              text:
                  'Invite your friends, add group photos, create prompts, and start exploring with your friends.',
              style: AppTextStyles.body(
                context,
              ).copyWith(color: ColorPalette.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const CustomSizedBox(height: 30),
          Center(
            child: AppText(
              text: 'You can add up to 4 members in a group.',
              style: AppTextStyles.description(context).copyWith(
                color: ColorPalette.textPrimary.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const CustomSizedBox(height: 20),
          BlocBuilder<CreateGroupCubit, CreateGroupState>(
            bloc: cubit,
            builder: (context, state) {
              final selectedMembers = cubit.selectedMembers;
              return _MembersWrap(
                selectedMembers: selectedMembers,
                onAddTap: () {
                  AutoRouter.of(context).push(const AddMemberRoute());
                },
                onRemove: (index) {
                  cubit.removeMember(index);
                },
              );
            },
          ),
          // Short Bio Section
          AppText(
            text: 'Short Bio',
            style: AppTextStyles.subHeading(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          CustomLabelTextField(
            controller: _bioController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Type here...',
            hintStyle: AppTextStyles.body(
              context,
            ).copyWith(color: ColorPalette.white.withValues(alpha: 0.4)),
            filled: false,
            maxLines: 4,
          ),
          const CustomSizedBox(height: 30),
          // Interests Section
          AppText(
            text: 'What fits your group well?',
            style: AppTextStyles.inputLabel(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          const CustomSizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InterestChip(
                emoji: '🏔️',
                label: 'Travel & Adventure',
                isSelected: _selectedInterests.contains('travel'),
                onTap: () => _toggleInterest('travel'),
              ),
              InterestChip(
                emoji: '🎵',
                label: 'Music & Arts',
                isSelected: _selectedInterests.contains('music'),
                onTap: () => _toggleInterest('music'),
              ),
              InterestChip(
                emoji: '🍔',
                label: 'Food & Drink',
                isSelected: _selectedInterests.contains('food'),
                onTap: () => _toggleInterest('food'),
              ),
              InterestChip(
                emoji: '🧘',
                label: 'Wellness & Lifestyle',
                isSelected: _selectedInterests.contains('wellness'),
                onTap: () => _toggleInterest('wellness'),
              ),
              InterestChip(
                emoji: '⚽',
                label: 'Sports & Outdoors',
                isSelected: _selectedInterests.contains('sports'),
                onTap: () => _toggleInterest('sports'),
              ),
              InterestChip(
                emoji: '🎉',
                label: 'Events & Parties',
                isSelected: _selectedInterests.contains('events'),
                onTap: () => _toggleInterest('events'),
              ),
            ],
          ),

          const CustomSizedBox(height: 130),
        ],
      ),
    );
  }
}

class _MembersWrap extends StatelessWidget {
  final List<Contact> selectedMembers;
  final VoidCallback onAddTap;
  final Function(int) onRemove;

  const _MembersWrap({
    required this.selectedMembers,
    required this.onAddTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cappedMembers = selectedMembers.take(4).toList();
    final memberSlots = List.generate(4, (index) {
      if (index < cappedMembers.length) {
        final contact = cappedMembers[index];
        return _MemberSlot(
          contact: contact,
          label: contact.displayName.isNotEmpty
              ? contact.displayName
              : 'Member',
          subtitle: _primaryMaskedPhone(contact),
          roleLabel: 'Invited',
          onRemove: () => onRemove(index),
        );
      }
      return _MemberSlot(isAdd: true, label: 'Add Member', onAdd: onAddTap);
    });

    final allSlots = [
      _MemberSlot(
        isAdmin: true,
        imagePath: Assets.dummy.a1.path,
        label: 'You',
        roleLabel: 'Admin',
      ),
      ...memberSlots,
    ];

    final topRow = allSlots.take(3).toList();
    final bottomRow = allSlots.skip(3).take(2).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < topRow.length; i++) ...[
              topRow[i],
              if (i != topRow.length - 1) const SizedBox(width: 36),
            ],
          ],
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < bottomRow.length; i++) ...[
              bottomRow[i],
              if (i != bottomRow.length - 1) const SizedBox(width: 48),
            ],
          ],
        ),
      ],
    );
  }
}

class _MemberSlot extends StatelessWidget {
  final Contact? contact;
  final bool isAdd;
  final bool isAdmin;
  final String? imagePath;
  final String label;
  final String? subtitle;
  final String? roleLabel;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const _MemberSlot({
    this.contact,
    this.isAdd = false,
    this.isAdmin = false,
    this.imagePath,
    this.label = '',
    this.subtitle,
    this.roleLabel,
    this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 96;
    final String initial = _initialFor(contact);
    final bool showRemove = !isAdd && !isAdmin && onRemove != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: isAdd ? onAdd : null,
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isAdd || contact != null
                      ? LinearGradient(
                          colors: [
                            ColorPalette.primary.withValues(alpha: 0.85),
                            ColorPalette.secondary.withValues(alpha: 0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: imagePath != null
                      ? Colors.transparent
                      : ColorPalette.secondary,
                ),
                child: isAdd
                    ? Assets.icons.userPlus.svg(width: 34, height: 34)
                    : imagePath != null
                    ? ClipOval(
                        child: Image.asset(
                          imagePath!,
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Text(initial, style: AppTextStyles.h2(context)),
              ),
            ),
            if (roleLabel != null)
              Positioned(
                bottom: -10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPalette.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      text: roleLabel!,
                      style: AppTextStyles.inputLabel(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            if (showRemove)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette.error,
                    ),
                    child: Assets.icons.cancel.svg(
                      width: 12,
                      height: 12,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        AppText(
          text: label,
          style: AppTextStyles.description(
            context,
          ).copyWith(color: ColorPalette.textSecondary),
        ),
        if (subtitle != null && subtitle!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: AppText(
              text: subtitle!,
              style: AppTextStyles.bodySmall(context).copyWith(
                color: ColorPalette.textPrimary.withValues(alpha: 0.6),
              ),
            ),
          ),
      ],
    );
  }
}

String _initialFor(Contact? contact) {
  final name = contact?.displayName.trim();
  if (name == null || name.isEmpty) {
    return '?';
  }
  return name[0].toUpperCase();
}

String? _primaryMaskedPhone(Contact contact) {
  if (contact.phones.isEmpty) {
    return null;
  }
  final raw = contact.phones.first.number.trim();
  return _maskPhone(raw);
}

String _maskPhone(String number) {
  final cleaned = number.replaceAll(RegExp(r'\s+'), '');
  if (cleaned.length <= 6) {
    return cleaned;
  }
  final prefix = cleaned.substring(0, 4);
  final suffix = cleaned.substring(cleaned.length - 2);
  return '$prefix*****$suffix';
}
