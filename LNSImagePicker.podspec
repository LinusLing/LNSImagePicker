Pod::Spec.new do |s|
  s.name         = "LNSImagePicker"

  s.version      = "1.0.0"

  s.summary      = "A WeiXin like multiple image picker (pro version)."

  s.platform = :ios

  s.ios.deployment_target = '8.0'

  s.requires_arc = true

  s.description  =  "A WeiXin like multiple image/video picker using ALAssetsLibrary and compatible for iOS7 and higher (pro version)"

  s.homepage     = "https://github.com/LinusLing/LNSImagePicker"

  s.license      = "MIT"

  s.author             = { "LinusLing" => "linusling419@gmail.com" }

  s.source       = { :git => "https://github.com/LinusLing/LNSImagePicker.git", :tag => "#{s.version}" }

  s.framework = "UIKit"

  s.source_files  = "LNSImagePicker/MTImagePicker", "LNSImagePicker/LNSImagePicker/**/*.{swift}"

  s.resource_bundle =  { "LNSImagePicker" => "LNSImagePicker/LNSImagePicker/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}" }

  s.swift_version = '4.0'

end
