// Autogenerated from Pigeon (v22.7.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

class SFSafariViewControllerOptions {
  SFSafariViewControllerOptions({
    this.preferredBarTintColor,
    this.preferredControlTintColor,
    this.barCollapsingEnabled,
    this.entersReaderIfAvailable,
    this.dismissButtonStyle,
    this.modalPresentationStyle,
    this.pageSheet,
  });

  int? preferredBarTintColor;

  int? preferredControlTintColor;

  bool? barCollapsingEnabled;

  bool? entersReaderIfAvailable;

  int? dismissButtonStyle;

  int? modalPresentationStyle;

  UISheetPresentationControllerConfiguration? pageSheet;

  Object encode() {
    return <Object?>[
      preferredBarTintColor,
      preferredControlTintColor,
      barCollapsingEnabled,
      entersReaderIfAvailable,
      dismissButtonStyle,
      modalPresentationStyle,
      pageSheet,
    ];
  }

  static SFSafariViewControllerOptions decode(Object result) {
    result as List<Object?>;
    return SFSafariViewControllerOptions(
      preferredBarTintColor: result[0] as int?,
      preferredControlTintColor: result[1] as int?,
      barCollapsingEnabled: result[2] as bool?,
      entersReaderIfAvailable: result[3] as bool?,
      dismissButtonStyle: result[4] as int?,
      modalPresentationStyle: result[5] as int?,
      pageSheet: result[6] as UISheetPresentationControllerConfiguration?,
    );
  }
}

class UISheetPresentationControllerConfiguration {
  UISheetPresentationControllerConfiguration({
    required this.detents,
    this.largestUndimmedDetentIdentifier,
    this.prefersScrollingExpandsWhenScrolledToEdge,
    this.prefersGrabberVisible,
    this.prefersEdgeAttachedInCompactHeight,
    this.preferredCornerRadius,
  });

  List<String> detents;

  String? largestUndimmedDetentIdentifier;

  bool? prefersScrollingExpandsWhenScrolledToEdge;

  bool? prefersGrabberVisible;

  bool? prefersEdgeAttachedInCompactHeight;

  double? preferredCornerRadius;

  Object encode() {
    return <Object?>[
      detents,
      largestUndimmedDetentIdentifier,
      prefersScrollingExpandsWhenScrolledToEdge,
      prefersGrabberVisible,
      prefersEdgeAttachedInCompactHeight,
      preferredCornerRadius,
    ];
  }

  static UISheetPresentationControllerConfiguration decode(Object result) {
    result as List<Object?>;
    return UISheetPresentationControllerConfiguration(
      detents: (result[0] as List<Object?>?)!.cast<String>(),
      largestUndimmedDetentIdentifier: result[1] as String?,
      prefersScrollingExpandsWhenScrolledToEdge: result[2] as bool?,
      prefersGrabberVisible: result[3] as bool?,
      prefersEdgeAttachedInCompactHeight: result[4] as bool?,
      preferredCornerRadius: result[5] as double?,
    );
  }
}


class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    }    else if (value is SFSafariViewControllerOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    }    else if (value is UISheetPresentationControllerConfiguration) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129: 
        return SFSafariViewControllerOptions.decode(readValue(buffer)!);
      case 130: 
        return UISheetPresentationControllerConfiguration.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class CustomTabsApi {
  /// Constructor for [CustomTabsApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  CustomTabsApi({BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : pigeonVar_binaryMessenger = binaryMessenger,
        pigeonVar_messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? pigeonVar_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  final String pigeonVar_messageChannelSuffix;

  Future<void> launch(String urlString, {required bool prefersDeepLink, SFSafariViewControllerOptions? options, }) async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.flutter_custom_tabs_ios.CustomTabsApi.launch$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[urlString, prefersDeepLink, options]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> closeAllIfPossible() async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.flutter_custom_tabs_ios.CustomTabsApi.closeAllIfPossible$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(null) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<String?> mayLaunch(List<String> urlStrings) async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.flutter_custom_tabs_ios.CustomTabsApi.mayLaunch$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[urlStrings]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return (pigeonVar_replyList[0] as String?);
    }
  }

  Future<void> invalidate(String sessionId) async {
    final String pigeonVar_channelName = 'dev.flutter.pigeon.flutter_custom_tabs_ios.CustomTabsApi.invalidate$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(<Object?>[sessionId]) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }
}
