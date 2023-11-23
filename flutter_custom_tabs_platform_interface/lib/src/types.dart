import 'package:meta/meta.dart';

/// The base options for Custom Tabs implementation.
///
/// Platform specific implementations can add additional fields by extending
/// this class.
///
@immutable
class PlatformOptions {
  /// Converts this instance into a [Map] instance for serialization.
  Map<String, dynamic> toMap() => {};
}
