#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_custom_tabs_ios.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_custom_tabs_ios'
  s.version          = '2.3.1'
  s.summary          = 'iOS platform implementation of flutter_custom_tabs.'
  s.description      = <<-DESC
iOS platform implementation of flutter_custom_tabs.
                       DESC
  s.homepage         = 'https://github.com/droibit/flutter_custom_tabs/'
  s.license          = { :type => 'Apache-2.0', :file => '../LICENSE' }
  s.author           = 'Shinya Kumagai'
  s.source           = { :http => 'https://github.com/droibit/flutter_custom_tabs/tree/develop/flutter_custom_tabs_ios' }
  s.documentation_url = 'https://pub.dev/packages/flutter_custom_tabs'
  s.source_files = 'flutter_custom_tabs_ios/Sources/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.swift_version = '5.0'
  s.resource_bundles = {'flutter_custom_tabs_ios_privacy' => ['flutter_custom_tabs_ios/Sources/flutter_custom_tabs_ios/Resources/PrivacyInfo.xcprivacy']}
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
