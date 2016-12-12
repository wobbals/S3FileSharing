#
# Be sure to run `pod lib lint S3FileSharing.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "S3FileSharing"
  s.version          = "0.0.1"
  s.summary          = "A short description of S3FileSharing."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
  This module demonstrates how to use AWS S3 to implement a basic file transfer.
                       DESC

  s.homepage         = "https://github.com/wobbals/S3FileSharing"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Charley Robinson" => "charley@tokbox.com" }
  s.source           = { :git => "https://github.com/wobbals/S3FileSharing.git", :branch => 'master' }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  # s.resource_bundles = {
  #   'S3FileSharing' => ['Pod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'AWSS3', '2.3.6'
   s.dependency 'AWSCore', '2.3.6'
   s.dependency 'CocoaLumberjack', '2.2.0'
   s.dependency 'OpenTok'
end
