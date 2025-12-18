import 'dart:convert';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Country {
  final String iso;
  final String name;
  final String flag;
  final String? phoneCode;
  const Country({
    required this.iso,
    required this.name,
    required this.flag,
    this.phoneCode,
  });

  factory Country.fromJson(Map<String, dynamic> j) => Country(
    iso: j['iso'],
    name: j['name'],
    flag: j['flag'],
    phoneCode: j['phoneCode'],
  );
}

Future<List<Country>> loadCountries() async {
  final raw = await rootBundle.loadString(Assets.animations.countries);
  final phoneCodes = await rootBundle.loadString(
    Assets.animations.countriesPhoneCodes,
  );
  final Map<String, dynamic> phoneCodesMap = jsonDecode(phoneCodes);
  final List list = jsonDecode(raw);

  return list.map((e) {
    final countryData = Map<String, dynamic>.from(e);
    countryData['phoneCode'] = phoneCodesMap[countryData['iso']];
    return Country.fromJson(countryData);
  }).toList();
}

class PhoneNumberField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final void Function(String completePhoneNumber) onChanged;

  const PhoneNumberField({
    super.key,
    this.label,
    this.hintText,
    required this.onChanged,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  Country? _selected;
  late Future<List<Country>> _future;

  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlay;
  bool _open = false;

  final TextEditingController _search = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<Country> _filtered = [];

  @override
  void initState() {
    super.initState();
    _future = loadCountries();
    _phoneController.addListener(_notifyChange);
  }

  @override
  void dispose() {
    _close();
    _search.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    if (_selected != null && _phoneController.text.isNotEmpty) {
      final completeNumber = '${_selected!.phoneCode}${_phoneController.text}';
      widget.onChanged(completeNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          AppText(
            text: widget.label!,
            style: AppTextStyles.bodyLarge(
              context,
            ).copyWith(color: ColorPalette.white, fontWeight: FontWeight.w500),
          ),
        if (widget.label != null) CustomSizedBox(height: 8),

        FutureBuilder<List<Country>>(
          future: _future,
          builder: (_, snap) {
            if (!snap.hasData) {
              return _underline(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white70,
                  ),
                ),
              );
            }

            return _underline(
              child: Row(
                children: [
                  InkWell(
                    key: _key,
                    onTap: () => _toggle(snap.data!),
                    child: _flagBox(),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: AppTextStyles.bodyLarge(
                        context,
                      ).copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: widget.hintText ?? 'Enter phone number',
                        hintStyle: AppTextStyles.bodyLarge(
                          context,
                        ).copyWith(color: Colors.white.withOpacity(0.5)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _flagBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(_selected?.flag ?? '🇺🇸', style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            _selected?.phoneCode != null ? '${_selected!.phoneCode}' : '+1',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }

  Widget _underline({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _open ? Colors.white70 : Colors.white24),
        ),
      ),
      child: child,
    );
  }

  // ================= Dropdown =================

  void _toggle(List<Country> list) {
    _open ? _close() : _openMenu(list);
  }

  void _openMenu(List<Country> list) {
    _filtered = list;
    _search.clear();

    final box = _key.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate dropdown width (80% of screen or max 400px)
    final dropdownWidth = (screenWidth * 0.8).clamp(280.0, 400.0);

    // Calculate left position to center the dropdown
    final leftPosition = (screenWidth - dropdownWidth) / 2;

    // Calculate if dropdown should appear above or below
    final spaceBelow = screenHeight - (offset.dy + box.size.height);
    final showAbove = spaceBelow < 380 && offset.dy > 380;

    _overlay = OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: _close,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(child: Container()),
            Positioned(
              left: leftPosition,
              top: showAbove
                  ? offset.dy - 370
                  : offset.dy + box.size.height + 6,
              width: dropdownWidth,
              child: _dropdown(list),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlay!);
    setState(() => _open = true);
  }

  Widget _dropdown(List<Country> list) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(14),
      color: const Color(0xFF1E1E1E),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 360),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            _searchField(list),
            Divider(height: 1, color: Colors.white.withOpacity(0.1)),
            Expanded(child: _list()),
          ],
        ),
      ),
    );
  }

  Widget _searchField(List<Country> list) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _search,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(8),
          ),
          isDense: true,
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
        ),
        onChanged: (v) {
          _filtered = list
              .where((c) => c.name.toLowerCase().contains(v.toLowerCase()))
              .toList();
          _overlay?.markNeedsBuild();
        },
      ),
    );
  }

  Widget _list() {
    return ListView.separated(
      itemCount: _filtered.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.white.withOpacity(0.1)),
      itemBuilder: (_, i) {
        final c = _filtered[i];
        final selected = _selected?.iso == c.iso;

        return InkWell(
          onTap: () => _select(c),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(c.flag, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    c.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (c.phoneCode != null)
                  Text(
                    '+${c.phoneCode}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                const SizedBox(width: 8),
                if (selected) Icon(Icons.check, color: ColorPalette.primary),
              ],
            ),
          ),
        );
      },
    );
  }

  void _select(Country c) {
    _close();
    setState(() => _selected = c);
    _notifyChange();
  }

  void _close() {
    _overlay?.remove();
    _overlay = null;
    if (_open) setState(() => _open = false);
  }
}
