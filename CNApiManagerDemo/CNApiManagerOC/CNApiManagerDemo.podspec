Pod::Spec.new do |s|
  s.name         = 'CNApiManagerDemo'
  s.version      = '1.0.3'
  s.license      = 'MIT'
  s.homepage     = 'https://git.oschina.net/congni/CNApiManager-OC.git'
  s.authors      = { "葱泥" => "983818495@qq.com" }
  s.summary      = 'OC基本网络层封装'
  s.description      = <<-DESC
                      A longer description of U in Markdown format.

                      * IOS开发基本网络库
                      * pod使用方法: pod "CNApiManager"
                      * Try to keep it short, snappy and to the point.
                      * Finally, don't worry about the indent, CocoaPods strips it!
                      DESC

  s.platform     =  :ios, '7.0'
  s.source       =  { :git => "https://git.oschina.net/congni/CNApiManager-OC.git", :tag => s.version.to_s }
  s.requires_arc = true


  s.dependency 'AFNetworking', '~> 2.6.3'
end