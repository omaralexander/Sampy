# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Sampy' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

target ‘sampyiMessage’ do
  # Pods for Sampy

pod ‘Firebase’
pod ‘Firebase/Database’
pod ‘Firebase/Auth’
pod ‘Firebase/Storage’
pod ‘Firebase/Messaging’
pod 'Firebase/Performance'
pod ‘Mapbox-iOS-SDK', '~> 3.5'
pod ’MapboxNavigation', '~> 0.9.0’
pod ‘Canvas’
pod ‘GooglePlaces’
pod 'NVActivityIndicatorView'
pod 'BEMCheckBox'
pod 'CHIPageControl/Paprika'
pod 'Fabric'
pod 'Crashlytics'
pod 'NotificationBannerSwift’, '~> 1.5.1’
	end
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['NotificationBannerSwift', 'SnapKit', 'MarqueeLabel'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
