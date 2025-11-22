---
applyTo: "flutter_custom_tabs_platform_interface/**"
---

# GitHub Copilot Instructions for `flutter_custom_tabs_platform_interface`

This file provides context for the **platform interface package**.

## Path

`flutter_custom_tabs_platform_interface/`

## Core Responsibilities

- **API Contract:** This package defines the abstract contract that all platform implementations MUST adhere to. It is the single source of truth for the plugin's API.
- **Abstract Classes and Models:** It contains the `CustomTabsPlatform` abstract class, method channel implementation, and any data models (like `CustomTabsOptions`) that are passed between the app-facing layer and the platform implementations.

## Key Principles

- **ALL API CHANGES START HERE.** If you are adding a new method, parameter, or data class, you must add it to this package first.
- **NO CONCRETE IMPLEMENTATIONS.** The code in this package must be abstract. It defines *what* the plugin can do, but not *how* it's done on a specific platform. The only exception is the `MethodChannelCustomTabs` class, which serves as the default channel-based implementation.
- **Maintain Backwards Compatibility:** Be cautious when changing existing APIs. If a breaking change is necessary, the major version must be incremented according to the pub versioning policy.
- **Throw `UnimplementedError`:** New methods in the `CustomTabsPlatform` class should throw an `UnimplementedError` by default. This ensures that existing platform implementations that haven't been updated yet will fail gracefully.

## Development

This section outlines the common commands used for development in the `flutter_custom_tabs_platform_interface` package.
As this is a Dart-only package, there are no platform-specific example apps to build or run.

### Setup

Install Dart dependencies:

```bash
flutter pub get
```

### Formatting

To ensure consistent code style, use the following command:

```bash
dart format --set-exit-if-changed .
```

### Static Analysis

Check for potential issues and style violations in your code:

```bash
flutter analyze .
```

### Testing

Run the test suite for the package:

```bash
flutter test
```
