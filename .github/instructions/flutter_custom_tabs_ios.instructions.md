---
applyTo: "flutter_custom_tabs_ios/**"
---

# GitHub Copilot Instructions for `flutter_custom_tabs_ios`

This file provides context for the **iOS implementation package**.

## Path

`flutter_custom_tabs_ios/`

## Core Responsibilities

- **Implement the Contract:** Provides the concrete iOS implementation for the API defined in `flutter_custom_tabs_platform_interface`.
- **Native Interaction:** Contains the Swift code that interfaces with the iOS `SafariServices` framework, specifically `SFSafariViewController`, to provide a customizable in-app browser experience.
- **Registration:** Registers itself as the canonical iOS implementation of the platform interface.

## Technical Specifications

- **Minimum iOS Version:** 12.0
- **Swift Version:** 5.9

## Architecture Overview

The iOS implementation is split between Dart and Swift, communicating via Pigeon.

### Dart Side

- `lib/flutter_custom_tabs_ios.dart`: The main entry point. It registers this package as the iOS implementation of `CustomTabsPlatform`.
- `lib/src/custom_tabs_plugin_ios.dart`: The plugin's core Dart class. It implements `CustomTabsPlatform` and translates calls into Pigeon messages for the native side.
- `lib/src/types/*.dart`: A collection of data classes, with `safari_view_controller_options.dart` being the main entry point for developers to configure the Custom Tab's appearance and behavior. These options are serialized into a `Map` for Pigeon.

### Swift Side

The native side has a clear separation of concerns:

- `CustomTabsPlugin.swift`: The standard Flutter plugin entry point. Its primary role is to set up the Pigeon channel and wire it to the `Launcher`. It implements the generated `CustomTabsApiProtocol`.
- `Launcher.swift`: The core logic hub. It receives commands from Dart (via `CustomTabsPlugin`) and orchestrates the presentation and dismissal of `SFSafariViewController`.
- `SFSafariViewController+Factory.swift`: A helper responsible for converting the options from Dart into a fully configured `SFSafariViewController` instance.

## Platform Channel: Pigeon

We use [Pigeon](https://pub.dev/packages/pigeon) for type-safe platform channel communication.

- **Schema:** Defined in `pigeons/messages.dart`. This file is the source of truth for the Dart-Swift API.
- **Implementation:** The generated `CustomTabsApi` protocol is implemented by `CustomTabsPlugin.swift` on the native side. The Dart client is used in `custom_tabs_plugin_ios.dart`.
- **Code Generation:** To regenerate the communication code after modifying the schema, run `dart run pigeon --input pigeons/messages.dart` from the package root.

## Coding Style and Conventions

- **Dart:** Follow the project's general Dart guidelines.
- **Swift:** Adhere to the rules defined in `.swiftlint.yml` and `.swiftformat`. Use the `Makefile` in the package root to run the tools:
  - `make lint`: To check for style violations.
  - `make format`: To automatically format the code.

## Key Contributor Workflow

When adding a new feature (e.g., a new customization option):

1. **Dart Options:** Add the new option to the relevant class in `lib/src/types/`. For example, a new UI option would go into `safari_view_controller_options.dart`.
1. **Pigeon Schema:** If the new option needs to be passed to the native side, update the data structures in `pigeons/messages.dart` and regenerate the code.
1. **Native Implementation:** Update `SFSafariViewController+Factory.swift` to read the new option and apply it to the `SFSafariViewController` or its `configuration`.
1. **Connect Dart to Native:** Ensure the top-level Dart plugin class (`custom_tabs_plugin_ios.dart`) correctly passes the new option through the Pigeon channel.

## Development

This section outlines the common commands used for development in the `flutter_custom_tabs_ios` package.

### Setup

Install Dart dependencies:

```bash
flutter pub get
```

### Code Generation (Pigeon)

If you modify the platform channel API in `pigeons/messages.dart`, regenerate the communication code:

```bash
flutter pub run pigeon --input pigeons/messages.dart
```

### Formatting

To ensure consistent code style, use the following commands:

**Dart:**

```bash
dart format -o none --set-exit-if-changed $(find ./lib ./test -name "*.dart" -not -name "*.*g.dart")
```

**Swift:**

```bash
make format
```

### Static Analysis

Check for potential issues and style violations in your code.

**Dart:**

```bash
flutter analyze .
```

**Swift:**

```bash
make lint
```

### Testing

Run the test suites for both Dart and the native iOS code.

**Dart:**

```bash
flutter test
```

**iOS (from the `example` directory):**

```bash
cd example
make test
```

### Building and Running the Example App

To build the example app for iOS (without code signing):

```bash
cd example
flutter build ios --no-codesign
```

To run the example app:

```bash
cd example
flutter run
```
