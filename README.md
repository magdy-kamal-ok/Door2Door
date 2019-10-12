
# Door2Door
Release notes : Xcode Version : Developed in Xcode 10.3 Swift Version : Swift 5.0 Architecture : MVVM, with MVI (using RxSwift, RxCocoa).
projects is Separated in 2 Different projects for Working in Modularity(as i notice you are going to work on Ongoing SDK so it the perfect solution to be modularized),
one project for Networking, the other for Booking Vehicle Events.

# functionality:
	1- live tracking for vehicle Location.
    2- show DropOff, Pickup, IntrmediateStop Locations on map Each with different AnnotationView
    3- show Loader for first Case Connection is Slow as you described it might happens.
    4- show DropOff, Pickup, IntrmediateStop Address UI Component.



# FrameWorks:
	1- RxSwift, RxCocoa for reactive programing and binding on ui components.
    2- RxBlocking, RxTest for testing Reactive Code mentioned before.
    3- StarScream for Live Events sent by WebSocket, especially it works in background.
    
# Usage:
	just download the .zip file and open Door2Door.xcworkspace, if you faced any problem just go to the project path and run command pod install.