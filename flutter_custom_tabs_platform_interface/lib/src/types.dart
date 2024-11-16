import 'package:meta/meta.dart';

/// The base options for Custom Tabs implementation.
///
/// Platform specific implementations can add additional fields by extending
/// this class.
///
@immutable
interface class PlatformOptions {}

/// The base session for Custom Tabs implementation.
///
/// Platform specific implementations can add additional fields by extending
/// this class.
///
@immutable
interface class PlatformSession {}
