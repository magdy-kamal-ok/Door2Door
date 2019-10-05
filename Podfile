# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!
inhibit_all_warnings!
workspace "Door2Door"

def commonFrameworks

    pod 'RxSwift', '~> 5'
    pod 'RxCocoa', '~> 5'
    pod 'Starscream', '~> 3.1.0'
end


target 'Door2Door' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks

  commonFrameworks

  target 'Door2DoorTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Door2DoorUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'Network-lib' do
    project 'Door2Door/Core/Network-lib/Network-lib.xcodeproj'
    
    target 'Network-libTests' do
        commonFrameworks
    end
    commonFrameworks
end
