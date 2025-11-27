// swiftlint:disable object_literal function_body_length

import SafariServices
import XCTest
@testable import flutter_custom_tabs_ios

private typealias DismissButtonStyle = SFSafariViewController.DismissButtonStyle

final class SFSafariViewControllerFactoryTest: XCTestCase {
  func testMakeWithMinimumOptions() throws {
    let actual = try SFSafariViewController.make(
      url: XCTUnwrap(URL(string: "https://example.com")),
      options: .init()
    )
    // Validation of default values for non-null values.
    XCTAssertTrue(actual.configuration.barCollapsingEnabled)
    XCTAssertFalse(actual.configuration.entersReaderIfAvailable)
    if #available(iOS 26, *) {
      XCTAssertEqual(actual.dismissButtonStyle, .close)
    } else {
      XCTAssertEqual(actual.dismissButtonStyle, .done)
    }
    XCTAssertEqual(actual.modalPresentationStyle, .fullScreen)

    XCTAssertNil(actual.preferredBarTintColor)
    XCTAssertNil(actual.preferredControlTintColor)
    if #available(iOS 15, *) {
      XCTAssertNil(actual.sheetPresentationController)
    }
  }

  func testMakeWithCompleOptions() throws {
    let srcOptions = SFSafariViewControllerOptions(
      preferredBarTintColor: 0xFF000000,
      preferredControlTintColor: 0xFF000001,
      barCollapsingEnabled: true,
      entersReaderIfAvailable: false,
      dismissButtonStyle: Int64(DismissButtonStyle.cancel.rawValue),
      modalPresentationStyle: Int64(UIModalPresentationStyle.pageSheet.rawValue),
      pageSheet: .init(
        detents: ["large"],
        largestUndimmedDetentIdentifier: "medium"
      )
    )
    let actual = try SFSafariViewController.make(
      url: XCTUnwrap(URL(string: "https://example.com")),
      options: srcOptions
    )

    XCTAssertEqual(
      actual.configuration.barCollapsingEnabled,
      srcOptions.barCollapsingEnabled
    )

    XCTAssertEqual(
      actual.configuration.entersReaderIfAvailable,
      srcOptions.entersReaderIfAvailable
    )

    if #available(iOS 26, *) {
      XCTAssertNil(actual.preferredBarTintColor)
      XCTAssertNil(actual.preferredControlTintColor)
    } else {
      XCTAssertEqual(
        actual.preferredBarTintColor,
        UIColor(red: 0, green: 0, blue: 0, alpha: 1)
      )
      XCTAssertEqual(
        actual.preferredControlTintColor,
        UIColor(red: 0, green: 0, blue: 1 / 255, alpha: 1)
      )
    }

    XCTAssertEqual(
      actual.dismissButtonStyle,
      try DismissButtonStyle(rawValue: Int(XCTUnwrap(srcOptions.dismissButtonStyle)))
    )
    XCTAssertEqual(
      actual.modalPresentationStyle,
      try UIModalPresentationStyle(rawValue: Int(XCTUnwrap(srcOptions.modalPresentationStyle)))
    )

    if #available(iOS 15, *) {
      XCTAssertNotNil(actual.sheetPresentationController)
      // Validation of the rest of `testMakeWithCompleteSheetConfinuration`.
      XCTAssertEqual(
        actual.sheetPresentationController?.largestUndimmedDetentIdentifier,
        .medium
      )
    }
  }

  @available(iOS 15, *)
  func testMakeWithMinimumSheetConfiguration() throws {
    let actualViewController = try SFSafariViewController.make(
      url: XCTUnwrap(URL(string: "https://example.com")),
      options: .init(
        modalPresentationStyle: Int64(UIModalPresentationStyle.formSheet.rawValue),
        pageSheet: .init(detents: ["large"])
      )
    )
    XCTAssertNotNil(actualViewController.sheetPresentationController)

    let actual = try XCTUnwrap(actualViewController.sheetPresentationController)
    XCTAssertEqual(actual.detents, [.large()])
    XCTAssertNil(actual.largestUndimmedDetentIdentifier)
    XCTAssertNil(actual.preferredCornerRadius)

    // Validation of default values for non-null values.
    XCTAssertTrue(actual.prefersScrollingExpandsWhenScrolledToEdge)
    XCTAssertFalse(actual.prefersGrabberVisible)
    XCTAssertFalse(actual.prefersEdgeAttachedInCompactHeight)
  }

  @available(iOS 15, *)
  func testMakeWithCompleteSheetConfiguration() throws {
    let srcSheet = UISheetPresentationControllerConfiguration(
      detents: ["large", "medium"],
      largestUndimmedDetentIdentifier: "large",
      prefersScrollingExpandsWhenScrolledToEdge: true,
      prefersGrabberVisible: false,
      prefersEdgeAttachedInCompactHeight: true,
      preferredCornerRadius: 16.0
    )
    let actualViewController = try SFSafariViewController.make(
      url: XCTUnwrap(URL(string: "https://example.com")),
      options: .init(
        modalPresentationStyle: Int64(UIModalPresentationStyle.pageSheet.rawValue),
        pageSheet: srcSheet
      )
    )
    XCTAssertNotNil(actualViewController.sheetPresentationController)

    let actual = try XCTUnwrap(actualViewController.sheetPresentationController)
    XCTAssertEqual(actual.detents, [.large(), .medium()])
    XCTAssertEqual(actual.largestUndimmedDetentIdentifier, .large)
    XCTAssertEqual(
      actual.prefersScrollingExpandsWhenScrolledToEdge,
      srcSheet.prefersScrollingExpandsWhenScrolledToEdge
    )
    XCTAssertEqual(actual.prefersGrabberVisible, srcSheet.prefersGrabberVisible)
    XCTAssertEqual(
      actual.prefersEdgeAttachedInCompactHeight,
      srcSheet.prefersEdgeAttachedInCompactHeight
    )
  }
}
