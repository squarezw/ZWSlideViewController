#
# Be sure to run `pod lib lint ZWSlideViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ZWSlideViewController"
  s.version          = "0.1.0"
  s.summary          = "A short description of ZWSlideViewController."

  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/squarezw/ZWSlideViewController"
  s.screenshots      = "https://github.com/squarezw/ZWSlideViewController/raw/master/screenshot.gif"
  s.license          = 'MIT'
  s.author           = { "square" => "square.zhao.wei@gmail.com" }
  s.source           = { :git => "git@github.com:squarezw/ZWSlideViewController.git" }
  
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

end
