# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CouchSurfing' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CouchSurfing

pod 'Firebase/Auth'
pod 'Firebase/RemoteConfig'
pod 'Firebase/Database'
pod 'FSCalendar'
pod 'Alamofire'
pod 'Kingfisher'
pod 'SwiftConfettiView'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
            config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
        end
    end
end
