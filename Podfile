# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!
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

target 'NetworkManager' do
    project 'Door2Door/Core/NetworkManager/NetworkManager.xcodeproj'
    
    target 'NetworkManagerTests' do
        commonFrameworks
    end
    commonFrameworks
end

target 'Booking' do
    project 'Door2Door/Features/Booking/Booking.xcodeproj'
    target 'BookingTests' do
        commonFrameworks
    end
    commonFrameworks
    
    
end
