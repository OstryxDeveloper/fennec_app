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

### State Management Rules
- **[CUBIT_RULES.md](./CUBIT_RULES.md)** - Comprehensive rules for implementing Cubits in this codebase
  - Store data in variables, not in state classes
  - State classes should only represent UI state (loading, loaded, error)
  - Access data directly from Cubit instances

### Code Review
- **[DEEP_CODE_REVIEW.md](./DEEP_CODE_REVIEW.md)** - Detailed code review and recommendations
