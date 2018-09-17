#
# Be sure to run `pod lib lint SwiftChaining.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Chaining'
  s.version          = '0.4.0'
  s.summary          = 'Binding values with method chaining.'

  s.homepage         = 'https://github.com/objective-audio/SwiftChaining'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'git' => 'yukiyasos@gmail.com' }
  s.source           = { :git => 'https://github.com/objective-audio/SwiftChaining.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.3'

  s.source_files = 'SwiftChaining/Classes/**/*'

  s.swift_version = '4.2'

end
