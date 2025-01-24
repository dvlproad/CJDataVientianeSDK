Pod::Spec.new do |s|
  # 上传到github公有库:
  #验证方法1：pod lib lint CJDataVientianeSDK-Swift.podspec --sources='https://github.com/CocoaPods/Specs.git' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CJDataVientianeSDK-Swift.podspec --sources=master --allow-warnings --use-libraries --verbose
  #提交方法(github公有库)： pod trunk push CJDataVientianeSDK-Swift.podspec --allow-warnings
  
  s.name         = "CJDataVientianeSDK-Swift"
  s.version      = "0.0.1"
  s.summary      = "数据万象SDK"
  s.homepage     = "https://github.com/dvlproad/CJDataVientianeSDK"
  s.license      = "MIT"
  s.author       = "dvlproad"

  s.description  = <<-DESC
                   A longer description of CJDataVientianeSDK-Swift in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "9.0"
  s.swift_version = '5.0'

  s.source       = { :git => "https://github.com/dvlproad/CJDataVientianeSDK", :tag => "CJDataVientianeSDK-Swift_0.0.1" }
  # s.source_files  = "CJBaseUtil/*.{h,m}"
  # s.resources = "CJBaseUtil/**/*.{png}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  # 基础的帮助类
  s.subspec 'Date' do |ss|
    ss.source_files = "CJDataVientianeSDK-Swift/Date/**/*.{swift}"
  end
  
  # 插入数据
  s.subspec 'Insert' do |ss|
    ss.source_files = "CJDataVientianeSDK-Swift/Insert/**/*.{swift}"
  end

end
