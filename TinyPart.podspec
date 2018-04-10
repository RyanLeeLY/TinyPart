#
#  Be sure to run `pod spec lint TinyPart.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "TinyPart"
  s.version      = "0.1.0"
  s.summary      = "TinyPart Framework"
  s.description  = <<-DESC
                    TinyPart is a modular framework in iOS.
                   DESC

  s.homepage     = "https://github.com/RyanLeeLY/TinyPart"
  s.license      = "MIT"
  s.author       = { "yao.li" => "liyao1021@163.com" }
  s.source       = { :git => "https://github.com/RyanLeeLY/TinyPart.git", :tag => "#{s.version}" }
  s.source_files  = "TinyPart/Classes/**/*.{h,m}"
  s.public_header_files = 'TinyPart/Classes/**/*.h'

  s.platform     = :ios, "8.0"
  s.framework  = 'Foundation', 'UIKit'
  s.requires_arc = true

end
