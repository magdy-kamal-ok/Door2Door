//
//  BookingViewModelTests.swift
//  BookingTests
//
//  Created by mac on 10/12/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import NetworkManager
@testable import Booking

class BookingViewModelTests: XCTestCase {


    let requestFactory = RequestFactory.init(endPoint: "BookingEvents")
    let disposeBag = DisposeBag()
    var sut: BookingViewModel?
    var testScheduler: TestScheduler?

    override func setUp() {
        let eventDataProvider: EventDataProvider<BookingEvent> = EventDataProvider.init(requestHandler: requestFactory, socketManager: MockedSocketManager.init())
        sut = BookingViewModel(eventDataProvider: eventDataProvider)
        testScheduler = TestScheduler.init(initialClock: 0)
    }

    override func tearDown() {
        sut = nil
        testScheduler?.stop()
    }

    func testBookingStatusSubscribtions() {

        let bookingStatusObserver = testScheduler?.createObserver(String.self)
        self.sut?
        .output
        .bookingStatus
        .subscribe(bookingStatusObserver!)
        .disposed(by: self.disposeBag)
        testScheduler?.start()
        sut?.getLiveEvents()
        let _ = try! sut?.bookingEventsGetterObservable?.toBlocking().toArray()
        
        XCTAssert(bookingStatusObserver?.events.count == 5)
        XCTAssert(bookingStatusObserver?.events.first?.value.element == "Waiting for Pickup")
         XCTAssert(bookingStatusObserver?.events.last?.value.element == "Booking Closed")
    }
    
    func testBookingVehicleLocationSubscribtions() {
        
        let vehicleLocationObserver = testScheduler?.createObserver(Location?.self)
        self.sut?
            .output
            .vehicleLocation
            .subscribe(vehicleLocationObserver!)
            .disposed(by: self.disposeBag)
        testScheduler?.start()
        sut?.getLiveEvents()
        let _ = try! sut?.bookingEventsGetterObservable?.toBlocking().toArray()
        
        XCTAssert(vehicleLocationObserver?.events.count == 16)
        let firstLocation = vehicleLocationObserver?.events.first?.value.element
        XCTAssertNil(firstLocation??.bearing)
        let lastLocation = vehicleLocationObserver?.events.last?.value.element
        XCTAssertNotNil(lastLocation??.bearing)
    }
    
    func testBookingintermediateStopLocationsSubscribtions() {
        
        let intermediateStopLocationsObserver = testScheduler?.createObserver([Location]?.self)
        self.sut?
            .output
            .intermediateStopLocations
            .subscribe(intermediateStopLocationsObserver!)
            .disposed(by: self.disposeBag)
        testScheduler?.start()
        sut?.getLiveEvents()
        let _ = try! sut?.bookingEventsGetterObservable?.toBlocking().toArray()
        
        XCTAssert(intermediateStopLocationsObserver?.events.count == 1)
        let locations = intermediateStopLocationsObserver?.events.first?.value.element
        XCTAssert(locations??.count == 2)

    }

    func testBookingPickupLocationSubscribtions() {
        
        let pickupLocationObserver = testScheduler?.createObserver(Location?.self)
        self.sut?
            .output
            .pickupLocation
            .subscribe(pickupLocationObserver!)
            .disposed(by: self.disposeBag)
        testScheduler?.start()
        sut?.getLiveEvents()
        let _ = try! sut?.bookingEventsGetterObservable?.toBlocking().toArray()
        
        XCTAssert(pickupLocationObserver?.events.count == 1)
        let firstLocation = pickupLocationObserver?.events.first?.value.element
        XCTAssert(firstLocation??.address == "Volksbühne Berlin")
    }

    func testBookingDropoffLocationSubscribtions() {
        
        let dropoffLocationObserver = testScheduler?.createObserver(Location?.self)
        self.sut?
            .output
            .dropOffLocation
            .subscribe(dropoffLocationObserver!)
            .disposed(by: self.disposeBag)
        testScheduler?.start()
        sut?.getLiveEvents()
        let _ = try! sut?.bookingEventsGetterObservable?.toBlocking().toArray()
        
        XCTAssert(dropoffLocationObserver?.events.count == 1)
        let firstLocation = dropoffLocationObserver?.events.first?.value.element
        XCTAssert(firstLocation??.address == "Gendarmenmarkt")
    }
    
    func testBookingActivityIndicatorSubscribtions() {
        
        let activityIndicatorObserver = testScheduler?.createObserver(Bool.self)
        self.sut?
            .output
            .activityLoader
            .subscribe(activityIndicatorObserver!)
            .disposed(by: self.disposeBag)
        testScheduler?.start()
        sut?.getLiveEvents()
        let _ = try! sut?.bookingEventsGetterObservable?.toBlocking().toArray()
        
        XCTAssert(activityIndicatorObserver?.events.count == 2)
        let firstEvent = activityIndicatorObserver?.events.first?.value.element
        XCTAssert(firstEvent == true)
        let lastEvent = activityIndicatorObserver?.events.last?.value.element
        XCTAssert(lastEvent == false)
    }
}
