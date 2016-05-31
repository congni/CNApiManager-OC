Pod::Spec.new do |s|
  s.name         = 'CNApiManager'
  s.version      = '1.0.0'
  s.license      = 'MIT'
  s.homepage     = 'git@git.oschina.net:congni/CNApiManager-OC.git'
  s.authors      = '葱泥': '983818495@qq.com'
  s.summary      = 'OC基本网络层封装'

  s.platform     =  :ios, '7.0'
  s.source       =  git: 'git@git.oschina.net:congni/CNApiManager-OC.git', :tag => s.version
  s.source_files = 'CNApiManagerOC/CNBaseApiManager.h'
  s.requires_arc = true

  s.subspec 'CNApiManagerOC' do |ss|
    ss.source_files = 'CNApiManagerOC/*'
  end

  s.dependencies =	pod 'AFNetworking', '~> 2.6.3'
end