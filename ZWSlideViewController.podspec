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
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "square" => "square.zhao.wei@gmail.com" }
  s.source           = { :git => "git@bitbucket.org:squarezw/zwslideviewcontroller.git" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ZWSlideViewController' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
