#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_sbox.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_sbox'
  s.version          = '0.0.1'
  s.summary          = 'The flutter_sbox plugin for Flutter'
  s.description      = <<-DESC
The flutter_sbox plugin for Flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.vendored_frameworks = 'VendoredFrameworks/Libcore.xcframework'

  # fixed libresolv.tbd
  s.xcconfig = { 
    'OTHER_LDFLAGS' => '-lresolv' 
  }
end
