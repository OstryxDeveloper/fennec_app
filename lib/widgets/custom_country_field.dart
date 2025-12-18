import 'dart:convert';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show rootBundle, FilteringTextInputFormatter;

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
  final String? Function(String?)? validator;
  final Country? initialCountry;

  const PhoneNumberField({
    super.key,
    this.label,
    this.hintText,
    required this.onChanged,
    this.validator,
    this.initialCountry,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  Country? _selected;
  late Future<List<Country>> _future;
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _future = loadCountries();
    _phoneController.addListener(_notifyChange);

    // Set initial country if provided
    if (widget.initialCountry != null) {
      _selected = widget.initialCountry;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    if (_selected != null && _phoneController.text.isNotEmpty) {
      final completeNumber = '${_selected!.phoneCode}${_phoneController.text}';
      widget.onChanged(completeNumber);
    }

    // Clear error when user types
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  String? validate() {
    if (_selected == null) {
      return 'Please select a country';
    }

    if (_phoneController.text.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any non-digit characters for validation
    final digitsOnly = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length < 7) {
      return 'Phone number must be at least 7 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }

    // Use custom validator if provided
    if (widget.validator != null) {
      final completeNumber = '${_selected?.phoneCode}$digitsOnly';
      return widget.validator!(completeNumber);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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

            // Set default country if not selected and initial country not provided
            if (_selected == null &&
                widget.initialCountry == null &&
                snap.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final defaultCountry = snap.data!.firstWhere(
                  (c) => c.iso == 'US',
                  orElse: () => snap.data!.first,
                );
                setState(() {
                  _selected = defaultCountry;
                });
              });
            }

            return FormField<String>(
              validator: (_) {
                final error = validate();
                if (error != null) {
                  setState(() => _errorMessage = error);
                }
                return error;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _underline(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () =>
                                _showCountryBottomSheet(context, snap.data!),
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
                                hintText:
                                    widget.hintText ?? 'Enter phone number',
                                hintStyle: AppTextStyles.bodyLarge(context)
                                    .copyWith(
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (_) {
                                field.didChange(_phoneController.text);
                              },
                            ),
                          ),
                        ],
                      ),
                      hasError: _errorMessage != null,
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      AppText(
                        text: _errorMessage!,
                        style: AppTextStyles.bodyRegular(
                          context,
                        ).copyWith(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ],
                );
              },
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
        mainAxisSize: MainAxisSize.min,
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

  Widget _underline({required Widget child, bool hasError = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: hasError ? Colors.red : Colors.white24,
            width: hasError ? 1.5 : 1,
          ),
        ),
      ),
      child: child,
    );
  }

  void _showCountryBottomSheet(BuildContext context, List<Country> countries) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CountryBottomSheetContent(
        countries: countries,
        selectedCountry: _selected,
        onCountrySelected: (country) {
          setState(() {
            _selected = country;
          });
          _notifyChange();
        },
      ),
    );
  }

  // Expose validate method to parent
  String? getValidationError() {
    return validate();
  }

  // Method to trigger validation from parent
  void triggerValidation() {
    setState(() {
      _errorMessage = validate();
    });
  }
}

// Separate StatefulWidget to properly manage TextEditingController lifecycle
class _CountryBottomSheetContent extends StatefulWidget {
  final List<Country> countries;
  final Country? selectedCountry;
  final void Function(Country) onCountrySelected;

  const _CountryBottomSheetContent({
    required this.countries,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  State<_CountryBottomSheetContent> createState() =>
      _CountryBottomSheetContentState();
}

class _CountryBottomSheetContentState
    extends State<_CountryBottomSheetContent> {
  late TextEditingController _searchController;
  late List<Country> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCountries = List.from(widget.countries);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredCountries = List.from(widget.countries);
      } else {
        _filteredCountries = widget.countries
            .where(
              (c) => c.name.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Text(
                  'Select Country',
                  style: AppTextStyles.h1(context).copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 24,
                ),
              ],
            ),
          ),
          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search country',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white.withOpacity(0.5),
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Country list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredCountries.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.white.withOpacity(0.08)),
              itemBuilder: (_, index) {
                final country = _filteredCountries[index];
                final isSelected = widget.selectedCountry?.iso == country.iso;

                return InkWell(
                  onTap: () {
                    widget.onCountrySelected(country);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Text(
                          country.flag,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            country.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (country.phoneCode != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              '${country.phoneCode}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: ColorPalette.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
