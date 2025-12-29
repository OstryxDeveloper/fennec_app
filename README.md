# fennac_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Development Guidelines

### State Management

**CRITICAL: Read the Cubit Documentation First!**

We use **variable-based Cubit architecture** where:

- Variables store all data
- States only represent UI transitions
- Widgets access data from Cubit instances, not states

**Start Here:** [CUBIT_INDEX.md](./CUBIT_INDEX.md) - Complete navigation guide to all documentation

### Documentation Files

#### For Quick Reference (Developers)

- **[CUBIT_QUICK_REFERENCE.md](./CUBIT_QUICK_REFERENCE.md)** - Bookmark this! Patterns, copy-paste code, quick lookups

#### For Understanding

- **[CUBIT_RULES.md](./CUBIT_RULES.md)** - Core rules and best practices
- **[CUBIT_IMPLEMENTATION_GUIDE.md](./CUBIT_IMPLEMENTATION_GUIDE.md)** - Comprehensive guide with all patterns

#### For Implementation

- **[CUBIT_REFACTORING_EXAMPLES.md](./CUBIT_REFACTORING_EXAMPLES.md)** - Real examples from your codebase with templates

#### For Overview

- **[CUBIT_DOCUMENTATION.md](./CUBIT_DOCUMENTATION.md)** - Overview and navigation
- **[README_CUBIT_DOCUMENTATION.md](./README_CUBIT_DOCUMENTATION.md)** - Summary of what's available
- **[CUBIT_INDEX.md](./CUBIT_INDEX.md)** - Master index and learning paths

### Code Review

- **[DEEP_CODE_REVIEW.md](./DEEP_CODE_REVIEW.md)** - Detailed code review and recommendations

## The Cubit Pattern (TL;DR)

```dart
// STORE DATA IN VARIABLES
String selected = '';
List<String> items = [];

// EMIT STATES FOR UI CHANGES
void update(String value) {
  emit(MyLoading());      // Show loading
  selected = value;       // Update data
  emit(MyLoaded());       // Show result
}

// ACCESS FROM CUBIT IN WIDGETS
Text(cubit.selected)      // ✅ Correct
// NOT: Text(state.selected)  // ❌ Wrong
```

## Key Rules

✅ Store data in Cubit **variables**, not state classes
✅ Keep state classes lightweight (Initial, Loading, Loaded, Error)
✅ Emit states to trigger UI rebuilds
✅ Access data via `cubit.variable`
✅ Dispose controllers in `close()` method
✅ Organize variables by type (Strings, Numbers, Booleans, Collections, Controllers, Objects)

## Project Structure

```
lib/
├── main.dart
├── app/
│   ├── theme/          (ColorPalette, TextStyles)
│   ├── constants/      (App constants)
│   └── router/         (Route management)
├── core/
│   ├── di_container.dart  (Dependency injection - register all Cubits here)
├── pages/              (Feature modules)
│   ├── feature_name/
│   │   ├── presentation/
│   │   │   ├── bloc/
│   │   │   │   ├── cubit/      (Cubit with all data variables)
│   │   │   │   └── state/      (Lightweight state classes only)
│   │   │   ├── widgets/        (UI components)
│   │   │   └── screen/         (Feature screens)
│   │   ├── data/
│   │   │   └── models/         (Data models)
│   │   └── domain/             (Business logic)
├── widgets/            (Shared widgets)
├── helpers/            (Utility functions)
└── utils/              (Constants and utilities)
```

## Quick Links

| Need                      | File                                                             |
| ------------------------- | ---------------------------------------------------------------- |
| Quick patterns for coding | [CUBIT_QUICK_REFERENCE.md](./CUBIT_QUICK_REFERENCE.md)           |
| Understand the rules      | [CUBIT_RULES.md](./CUBIT_RULES.md)                               |
| Learn everything          | [CUBIT_IMPLEMENTATION_GUIDE.md](./CUBIT_IMPLEMENTATION_GUIDE.md) |
| See examples              | [CUBIT_REFACTORING_EXAMPLES.md](./CUBIT_REFACTORING_EXAMPLES.md) |
| Find what you need        | [CUBIT_INDEX.md](./CUBIT_INDEX.md)                               |
| Code review checklist     | [CUBIT_RULES.md](./CUBIT_RULES.md#refactoring-checklist)         |

## Onboarding Checklist

New to the project?

- [ ] Read [CUBIT_QUICK_REFERENCE.md](./CUBIT_QUICK_REFERENCE.md) (15 min)
- [ ] Read [CUBIT_RULES.md](./CUBIT_RULES.md) (20 min)
- [ ] Study examples in [CUBIT_REFACTORING_EXAMPLES.md](./CUBIT_REFACTORING_EXAMPLES.md) (20 min)
- [ ] Review existing cubits in `lib/pages/*/presentation/bloc/cubit/`
- [ ] Build your first feature using the patterns

## Common Tasks

### Create a New Cubit

1. Check similar example in [CUBIT_REFACTORING_EXAMPLES.md](./CUBIT_REFACTORING_EXAMPLES.md)
2. Copy the template from that file
3. Use method patterns from [CUBIT_QUICK_REFERENCE.md](./CUBIT_QUICK_REFERENCE.md)
4. Register in `lib/core/di_container.dart`

### Review a Cubit PR

1. Use checklist from [CUBIT_RULES.md](./CUBIT_RULES.md)
2. Compare to examples in [CUBIT_REFACTORING_EXAMPLES.md](./CUBIT_REFACTORING_EXAMPLES.md)
3. Verify variable organization from [CUBIT_IMPLEMENTATION_GUIDE.md](./CUBIT_IMPLEMENTATION_GUIDE.md)

### Debug a Cubit Issue

1. Check troubleshooting in [CUBIT_QUICK_REFERENCE.md](./CUBIT_QUICK_REFERENCE.md)
2. Add print statements to verify emissions
3. Verify widget accesses `cubit.variable` (not `state.variable`)
4. Check controllers are being disposed

### Refactor Existing Code

1. Follow checklist in [CUBIT_IMPLEMENTATION_GUIDE.md](./CUBIT_IMPLEMENTATION_GUIDE.md#refactoring-existing-cubits)
2. Move data from state classes to variables
3. Update widgets to access from cubit
4. Verify state emissions still work

## Team Guidelines

- **Follow the Cubit pattern strictly** - All data in variables, states for UI only
- **Organize variables by type** - Group Strings, Numbers, Booleans, Collections, etc.
- **Emit states consistently** - Always: emit(Loading) → update → emit(Loaded/Error)
- **Dispose resources** - Controllers and other resources in `close()` method
- **Access data correctly** - Use `cubit.variable`, never `state.variable`
- **Document public methods** - Add comments explaining what methods do
- **Review using checklist** - Use the provided checklist for all PRs

## Architecture Overview

**Clean Architecture + BLoC + GetIt**

```
PRESENTATION LAYER
├─ Widgets
├─ Screens
└─ Bloc/Cubit (Data in variables, States for UI)

DATA LAYER
├─ Models
└─ Repositories

DOMAIN LAYER
├─ Entities
└─ Use Cases

SERVICE LAYER
├─ API
├─ Local Storage
└─ Other Services
```

## Theme & Colors

Import and use the app's color palette:

```dart
import 'package:fennac_app/app/theme/app_colors.dart';

// Use in your widgets
color: ColorPalette.primary,
backgroundColor: ColorPalette.secondary,
```

See [lib/app/theme/app_colors.dart](./lib/app/theme/app_colors.dart) for all available colors.

## Dependency Injection

All Cubits are registered in [lib/core/di_container.dart](./lib/core/di_container.dart):

```dart
// Register a cubit
sl.registerLazySingleton<MyCubit>(() => MyCubit());

// Use in widget
final cubit = Di().sl<MyCubit>();
```

---

**For comprehensive documentation, see [CUBIT_INDEX.md](./CUBIT_INDEX.md)**
