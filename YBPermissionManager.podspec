#
#  Be sure to run `pod spec lint YBPermissionManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#


Pod::Spec.new do |s|

s.name         = "YBPermissionManager"
s.version      = "1.0.3"
s.summary      = "base permission settings for ubank project."

s.description  = <<-DESC
It is a base permission settings for ubank project. written by Object-C.
DESC

s.homepage     = "https://github.com/asance/YBPermissionManager"
s.license      = "MIT"
s.author             = { "asance" => "lidongwc@126.com" }

s.platform     = :ios
s.ios.deployment_target = "8.0"
s.source       = { :git => "https://github.com/asance/YBPermissionManager.git", :tag => "v#{s.version}" }
s.source_files  =  "YBPermissionManagerDemo/YBPermissionManagerDemo/YBPermissionManager/*.{h,m}"
s.frameworks = "UIKit", "CoreGraphics", "Foundation", "AddressBook", "Contacts", "CoreLocation", "Photos", "AssetsLibrary", "AVFoundation"
s.requires_arc = true
s.dependency 'YBBaseCategory', '~>1.0.1'

end

