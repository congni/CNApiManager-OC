Pod::Spec.new do |s|
  s.name         = 'CNApiManager-OC'
  s.version      = '1.0.9'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = 'https://github.com/congni/CNApiManager-OC.git'
  s.authors      = { "葱泥" => "983818495@qq.com" }
  s.summary      = 'OC基本网络层封装'
  s.description      = <<-DESC
                      A longer description of U in Markdown format.

                      * IOS开发基本网络库
                      * pod使用方法: pod "CNApiManager-OC"
                      * Try to keep it short, snappy and to the point.
                      * Finally, don't worry about the indent, CocoaPods strips it!
                      DESC

  s.ios.deployment_target = '7.0'
  s.source       =  { :git => "https://github.com/congni/CNApiManager-OC.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files = 'CNApiManagerOC/*.{h,m}'
  s.public_header_files = 'CNApiManagerOC/*.{h}'

  s.dependency 'AFNetworking', '~> 2.6.3'
end