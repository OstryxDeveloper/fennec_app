# Cubit State Management Rules

## Overview

This document defines the rules for implementing Cubits in this codebase. The core principle is: **Store data in variables, not in state classes. State classes should only represent UI state (loading, loaded, error, etc.).**

---

## Core Principles

### 1. **Data Storage in Variables**

- All business data, form data, and application state should be stored as **variables** in the Cubit class
- Variables should be typed according to their data type (String, int, bool, List, Map, custom classes, etc.)
- Variables should be declared at the class level, not inside methods

### 2. **State Classes for UI State Only**

- State classes should **only** represent UI state transitions:
  - `Initial` - Initial state
  - `Loading` - Operation in progress
  - `Loaded` - Operation completed successfully
  - `Error` - Operation failed
- State classes should **NOT** contain business data
- State classes should be lightweight and only used to trigger UI rebuilds

### 3. **Accessing Data**

- Access data directly from the Cubit instance: `cubit.variableName`
- Do not access data from state objects
- Use `BlocBuilder` or `BlocListener` to react to state changes, but read data from the Cubit

---

## Variable Naming Conventions

### Primitive Types

```dart
// String variables
String selectedCategory = 'Travel & Adventure';
String? selectedGender;
String errorMessage = '';

// Numeric variables
int selectedIndex = 0;
int validationCounter = 0;
double progressValue = 0.0;

// Boolean variables
bool obscurePassword = true;
bool isLoading = false;
bool isFormValid = false;
```

### Collections

```dart
// Lists
List<String> selectedInterests = [];
List<MediaItem> mediaList = [];
List<Widget> screens = [];

// Maps
Map<String, List<String>> interestCategories = {};
Map<String, dynamic> userData = {};
```

### Controllers

```dart
// TextEditingController
final firstNameController = TextEditingController();
final emailController = TextEditingController();

// ScrollController
FixedExtentScrollController? dayController;
FixedExtentScrollController? monthController;
```

### Custom Objects

```dart
// Custom classes
Country? selectedCountry;
DateTime? selectedDate;
UserModel? currentUser;
```

---

## State Class Structure

### Standard State Pattern

```dart
// ✅ CORRECT: Lightweight state classes
class FilterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FilterInitial extends FilterState {}
class FilterLoading extends FilterState {}
class FilterLoaded extends FilterState {}
class FilterError extends FilterState {}
```

### ❌ INCORRECT: Storing data in state

```dart
// ❌ DON'T DO THIS
class FilterLoaded extends FilterState {
  final String selectedCategory;  // ❌ Data should be in Cubit variable
  final List<String> categories;  // ❌ Data should be in Cubit variable

  FilterLoaded({required this.selectedCategory, required this.categories});
}
```

---

## Cubit Implementation Pattern

### Basic Structure

```dart
class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit() : super(ExampleInitial());

  // ========== DATA VARIABLES ==========
  // Store all data here, organized by type

  // String variables
  String selectedValue = '';
  String? optionalValue;

  // Numeric variables
  int counter = 0;
  double progress = 0.0;

  // Boolean variables
  bool isEnabled = true;
  bool obscureText = false;

  // Collections
  List<String> items = [];
  Map<String, dynamic> data = {};

  // Controllers
  final textController = TextEditingController();

  // Custom objects
  UserModel? currentUser;
  DateTime? selectedDate;

  // ========== METHODS ==========
  void updateValue(String value) {
    emit(ExampleLoading());  // Emit loading state
    selectedValue = value;   // Update variable
    emit(ExampleLoaded());   // Emit loaded state
  }

  void performAction() {
    emit(ExampleLoading());
    try {
      // Business logic here
      counter++;
      emit(ExampleLoaded());
    } catch (e) {
      emit(ExampleError());
    }
  }

  // Dispose controllers if needed
  @override
  Future<void> close() {
    textController.dispose();
    return super.close();
  }
}
```

---

## Examples from Codebase

### ✅ Example 1: FilterCubit (Correct Pattern)

```dart
class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());

  // Data stored in variables
  String selectedCategory = 'Travel & Adventure';
  String selectedGender = 'All genders';
  String selectedGroupSize = 'Max 3 people';
  String selectedDistance = 'Max 15 miles';
  String selectedAgeRange = '25 - 35 years old';

  // State classes only for UI state
  void updateCategory(String category) {
    emit(FilterLoading());      // UI state
    selectedCategory = category; // Data in variable
    emit(FilterLoaded());        // UI state
  }
}
```

### ✅ Example 2: AuthCubit (Correct Pattern)

```dart
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // UI state variables
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isEmail = true;

  // Controllers
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();

  // Validation tracking
  int _validationCounter = 0;
  bool _firstNameTouched = false;

  void togglePasswordVisibility() {
    emit(AuthValidationLoading());  // UI state
    obscurePassword = !obscurePassword; // Data in variable
    emit(AuthValidation(validationCounter: _validationCounter)); // UI state only
  }
}
```

### ✅ Example 3: ImagePickerCubit (Correct Pattern)

```dart
class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImagePickerInitial());

  // Data stored in variable
  List<MediaItem> mediaList = [];

  Future<void> pickImagesFromGallery() async {
    emit(ImagePickerLoading());  // UI state
    try {
      // Business logic
      final files = await _imagePicker.pickMultiImage();
      // Update data variable
      mediaList.addAll(/* processed files */);
      emit(ImagePickerLoaded()); // UI state (no data passed)
    } catch (e) {
      emit(ImagePickerError('Error message')); // UI state with error message only
    }
  }
}
```

### ⚠️ Example 4: ImagePickerState (Needs Refactoring)

```dart
// Current implementation passes data in state
class ImagePickerLoaded extends ImagePickerState {
  const ImagePickerLoaded({List<MediaItem>? mediaList})
    : super(mediaList: mediaList ?? const [], errorMessage: null);
}

// ✅ Should be refactored to:
class ImagePickerLoaded extends ImagePickerState {
  const ImagePickerLoaded();
}
// Data accessed via: cubit.mediaList
```

---

## Widget Usage Pattern

### Accessing Data from Cubit

```dart
class ExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = Di().sl<ExampleCubit>();

    return BlocBuilder<ExampleCubit, ExampleState>(
      builder: (context, state) {
        // React to state changes for UI updates
        if (state is ExampleLoading) {
          return CircularProgressIndicator();
        }

        if (state is ExampleError) {
          return Text('Error occurred');
        }

        // Access data directly from Cubit
        return Text(cubit.selectedValue);  // ✅ Direct access
        // NOT: state.selectedValue  // ❌ Wrong
      },
    );
  }
}
```

### Listening to State Changes

```dart
BlocListener<ExampleCubit, ExampleState>(
  listener: (context, state) {
    if (state is ExampleLoaded) {
      // Access data from Cubit, not state
      final data = context.read<ExampleCubit>().selectedValue;
      // Perform action
    }
  },
  child: YourWidget(),
)
```

---

## Data Type Organization

### Group Variables by Type

```dart
class ExampleCubit extends Cubit<ExampleState> {
  // ========== STRING VARIABLES ==========
  String primaryValue = '';
  String? optionalValue;
  String errorMessage = '';

  // ========== NUMERIC VARIABLES ==========
  int selectedIndex = 0;
  int counter = 0;
  double progress = 0.0;

  // ========== BOOLEAN VARIABLES ==========
  bool isEnabled = true;
  bool isLoading = false;
  bool obscureText = false;

  // ========== COLLECTIONS ==========
  List<String> items = [];
  List<MediaItem> mediaList = [];
  Map<String, dynamic> data = {};

  // ========== CONTROLLERS ==========
  final textController = TextEditingController();
  FixedExtentScrollController? scrollController;

  // ========== CUSTOM OBJECTS ==========
  UserModel? currentUser;
  DateTime? selectedDate;
  Country? selectedCountry;
}
```

---

## Method Implementation Rules

### 1. Always Emit Loading State Before Operations

```dart
void updateData(String value) {
  emit(ExampleLoading());  // ✅ Always emit loading first
  // Update variable
  selectedValue = value;
  emit(ExampleLoaded());
}
```

### 2. Update Variables, Not State

```dart
void updateData(String value) {
  emit(ExampleLoading());
  selectedValue = value;  // ✅ Update variable
  // NOT: emit(ExampleLoaded(data: value));  // ❌ Don't pass data in state
  emit(ExampleLoaded());
}
```

### 3. Error Handling

```dart
Future<void> performAsyncOperation() async {
  emit(ExampleLoading());
  try {
    // Business logic
    await someAsyncOperation();
    data = result;
    emit(ExampleLoaded());
  } catch (e) {
    errorMessage = e.toString();  // ✅ Store error in variable if needed
    emit(ExampleError());         // ✅ Emit error state
  }
}
```

### 4. Validation Pattern

```dart
class AuthCubit extends Cubit<AuthState> {
  int _validationCounter = 0;  // ✅ Track validation in variable

  void validateForm() {
    _validationCounter++;  // ✅ Increment counter
    emit(AuthValidation(validationCounter: _validationCounter)); // ✅ Pass counter for rebuild trigger
  }

  // Access validation state from variables
  String? getEmailError() {
    return _emailTouched ? validateEmail(emailController.text) : null;
  }
}
```

---

## Refactoring Checklist

When refactoring existing Cubits:

- [ ] Move all data from state classes to variables in Cubit
- [ ] Update state classes to be lightweight (no data properties)
- [ ] Update all methods to update variables instead of passing data in state
- [ ] Update widgets to access data from Cubit instance, not state
- [ ] Ensure state classes only represent UI state (Initial, Loading, Loaded, Error)
- [ ] Group variables by data type for better organization
- [ ] Add proper dispose methods for controllers

---

## Common Patterns

### Pattern 1: Simple Toggle

```dart
void toggleVisibility() {
  emit(ExampleLoading());
  obscureText = !obscureText;  // Update variable
  emit(ExampleLoaded());
}
```

### Pattern 2: Selection

```dart
void selectItem(String item) {
  emit(ExampleLoading());
  selectedItem = item;  // Update variable
  emit(ExampleLoaded());
}
```

### Pattern 3: List Operations

```dart
void addItem(String item) {
  emit(ExampleLoading());
  items.add(item);  // Update list variable
  emit(ExampleLoaded());
}

void removeItem(int index) {
  emit(ExampleLoading());
  items.removeAt(index);  // Update list variable
  emit(ExampleLoaded());
}
```

### Pattern 4: Async Operations

```dart
Future<void> fetchData() async {
  emit(ExampleLoading());
  try {
    final result = await apiService.getData();
    data = result;  // Update variable
    emit(ExampleLoaded());
  } catch (e) {
    errorMessage = e.toString();
    emit(ExampleError());
  }
}
```

### Pattern 5: Form Validation

```dart
void validateField(String value) {
  _fieldTouched = true;
  _validationCounter++;
  emit(AuthValidation(validationCounter: _validationCounter));
}

String? getFieldError() {
  return _fieldTouched ? validateField(fieldController.text) : null;
}
```

---

## Best Practices

1. **Always initialize variables with default values**

   ```dart
   String selectedValue = '';  // ✅ Not: String? selectedValue;
   ```

2. **Use nullable types only when necessary**

   ```dart
   DateTime? selectedDate;  // ✅ Nullable because it's optional
   String errorMessage = '';  // ✅ Non-nullable with default
   ```

3. **Group related variables together**

   ```dart
   // Group password-related variables
   bool obscurePassword = true;
   bool obscureConfirmPassword = true;
   final passwordController = TextEditingController();
   ```

4. **Use private variables for internal state**

   ```dart
   int _validationCounter = 0;  // ✅ Private for internal use
   bool _fieldTouched = false;   // ✅ Private for internal use
   ```

5. **Dispose controllers properly**

   ```dart
   @override
   Future<void> close() {
     textController.dispose();
     return super.close();
   }
   ```

6. **Emit states consistently**
   ```dart
   void updateData() {
     emit(ExampleLoading());  // ✅ Always emit loading first
     // Update variables
     emit(ExampleLoaded());   // ✅ Always emit loaded after
   }
   ```

---

## Summary

- ✅ **DO**: Store data in typed variables in the Cubit class
- ✅ **DO**: Use state classes only for UI state (Initial, Loading, Loaded, Error)
- ✅ **DO**: Access data directly from Cubit instance: `cubit.variableName`
- ✅ **DO**: Group variables by data type for organization
- ❌ **DON'T**: Store business data in state classes
- ❌ **DON'T**: Access data from state objects
- ❌ **DON'T**: Pass data through state constructors

---

## Quick Reference

```dart
// ✅ CORRECT PATTERN
class MyCubit extends Cubit<MyState> {
  // Data in variables
  String data = '';
  List<String> items = [];

  void update() {
    emit(MyLoading());
    data = 'new value';
    emit(MyLoaded());
  }
}

// Widget access
cubit.data  // ✅ Correct

// ❌ WRONG PATTERN
class MyState {
  final String data;  // ❌ Don't store data in state
}
```

---

_Last updated: Based on codebase analysis_
