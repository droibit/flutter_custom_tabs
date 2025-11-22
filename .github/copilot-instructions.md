# GitHub Copilot Instructions for the flutter_custom_tabs project

This document provides general context to GitHub Copilot for the `flutter_custom_tabs` federated plugin project. Specific implementation details for each package are located in the `.github/instructions/` directory.

## Project Overview: Federated Plugin Architecture

This project is a [Flutter federated plugin](https://flutter.dev/docs/development/packages-and-plugins/developing-packages#federated-plugins). It separates its API from platform-specific implementations. The key packages are:

- **`flutter_custom_tabs`:** The app-facing package that developers use.
- **`flutter_custom_tabs_platform_interface`:** The abstract API definition (the contract).
- **`flutter_custom_tabs_android`:** The Android implementation.
- **`flutter_custom_tabs_ios`:** The iOS implementation.
- **`flutter_custom_tabs_web`:** The web implementation.

Each package has its own specific instructions file in `.github/instructions/`. **Always refer to the specific instruction file for the package you are working on.**

## Development Environment

- **Flutter:** `3.19.3-stable`
- **Dart:** The Dart version is tied to the Flutter version.

## General Coding Style and Conventions

- **Dart:** Follow the guidelines from `package:flutter_lints/flutter.yaml`. The configuration is in the `analysis_options.yaml` of each package.
- **Null Safety:** The entire project is null-safe. Ensure all new code correctly handles nullability.
- **Markdown:** The project uses [markdownlint](https://github.com/DavidAnson/markdownlint) to enforce a consistent style for all Markdown documents. The configuration can be found in the root `.markdownlint-cli2.yaml` file. Please ensure your contributions adhere to these rules.

## General API Design

- New public APIs must be added to `flutter_custom_tabs_platform_interface` first. This is the source of truth for the plugin's API.
- The platform implementations must then be updated to support the new API.
- If a platform does not support a feature, it should throw an `UnimplementedError`.

## General Testing Philosophy

- All new features or bug fixes must be accompanied by tests.
- **Unit Tests:** Add tests for the app-facing package, platform interface, and each platform implementation. Mocks should be used where appropriate.
- **Platform-Specific Tests:** Native platform tests should be added for complex native logic.

## Documentation and Commits

- **CHANGELOG:** When you make changes to a package, update its `CHANGELOG.md` file. Follow the existing format:
  - Start with a `## <version>` header.
  - List each change as a bullet point (`-`).
- **Commit Messages:** Write clear and descriptive commit messages. Explain *why* a change was made, not just *what* was changed.
