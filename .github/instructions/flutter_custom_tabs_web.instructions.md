---
applyTo: "flutter_custom_tabs_web/**"
---

# GitHub Copilot Instructions for `flutter_custom_tabs_web`

This file provides context for the **web implementation package**.

## Path

`flutter_custom_tabs_web/`

## Core Responsibilities

- **Implement the Contract:** This package provides the concrete web implementation for the API defined in `flutter_custom_tabs_platform_interface`.
- **Browser Interaction:** It uses `package:url_launcher_web` to interact with the browser for launching URLs.
- **Registration:** The plugin registers itself as the web implementation using the standard Flutter web plugin registration mechanism.

## Implementation Details

- **No Platform Channels:** The web implementation is written entirely in Dart and does not use Pigeon or platform channels.
- **Dependency on url_launcher_web:** It relies on the `url_launcher_web` package to handle opening URLs in a new browser tab.
- **File Location:** The core logic is located in `lib/flutter_custom_tabs_web.dart`.
- **Platform Limitations:** Features specific to native platforms (like pre-warming the browser) are not supported on the web and are implemented as no-ops.

## Key Principles

- When modifying this package, the primary file you will edit is `lib/flutter_custom_tabs_web.dart`.
- The `launch` method is the entry point for opening a URL.
- **Options Handling:** The web implementation currently provides a basic URL launching capability. Customization options available on native platforms are generally ignored due to limitations of web browser APIs.

## Development

This section outlines the common commands used for development in the `flutter_custom_tabs_web` package.

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

Run the test suite for the package. Note that this requires Chrome to be installed.

```bash
flutter test --platform chrome
```

### Running the Example App

To run the example app on the web:

```bash
cd example
flutter run -d chrome
```
