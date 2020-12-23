platform :ios, 10.0
use_frameworks!

def shared_pods
  pod 'Alamofire'
end

target 'd63181fffacf7f55df742aa964ab9a35' do
  shared_pods
end

target 'd63181fffacf7f55df742aa964ab9a35Tests' do
  shared_pods
end

post_install do |installer|
  puts 'Patching SVGKit to compile with the ios 7 SDK'
  %x(patch Pods/path/to/file.m < localpods/patches/fix.patch)
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
