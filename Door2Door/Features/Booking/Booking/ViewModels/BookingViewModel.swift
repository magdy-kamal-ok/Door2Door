//
//  BookingViewModel.swift
//  Booking
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation
import NetworkManager
import RxSwift

/// this enum for location types that happens to be sent with each other
///
/// - vehicle: for vehicle location
/// - dropoff: for dropoff Location
/// - pickup: for pickup Location
enum LocationType
{
    case vehicle
    case dropoff
    case pickup
}

/// this is BookingViewModel it represents all the businees logic about the booking Module
class BookingViewModel {

    /// this is an object from the EventDataProvider so we can observe on the data returned from Socket
    private let eventDataProvider: EventDataProvider<BookingEvent>!

    /// DisposeBag for managing lifecycle of related Disposable
    private let disposeBag = DisposeBag()

    /// represnts all seuences returned form the EventDataProvider
    private var bookingEventsObservable: Observable<BookingEvent>?
    {
        didSet
        {
            self.handleLiveBookingEvents()
        }
    }

    /// it is just getter for bookingEventsObservable
    public var bookingEventsGetterObservable: Observable<BookingEvent>?
    {
        get
        {
            return self.bookingEventsObservable
        }
    }


    /// this Output represnts all sequences need will fire from the viewModel, all what you  need to to do is to subscripe for each one of this in the ViewController, and this is concept of MVI Architecture
    struct Output {
        let intermediateStopLocations: Observable<[Location]?>
        let pickupLocation: Observable<Location?>
        let dropOffLocation: Observable<Location?>
        let vehicleLocation: Observable<Location?>
        let bookingStatus: Observable<String>
        let activityLoader: Observable<Bool>
        let bookingBtnStatus: Observable<Bool>
        let userInformationStatus: Observable<Bool>
    }

    // MARK :- All thes parameters are subjects for the Output Expected From The ViewModel
    private var intermediateStopLocationsSubject = PublishSubject<[Location]?>()
    private var pickupLocationSubject = PublishSubject<Location?>()
    private var dropOffLocationSubject = PublishSubject<Location?>()
    private var vehicleLocationSubject = PublishSubject<Location?>()
    private var bookingStatusSubject = PublishSubject<String>()
    private var activityLoaderSubject = PublishSubject<Bool>()
    private var bookingBtnStatusSubject = PublishSubject<Bool>()
    private var userInformationSubject = PublishSubject<Bool>()
    private var previousVehicleLocation: Location? = nil
    public var output: Output!


    /// the initializer of BookingViewModel
    ///
    /// - Parameter eventDataProvider: it takes object of type EventDataProvider
    init(eventDataProvider: EventDataProvider<BookingEvent>) {

        self.eventDataProvider = eventDataProvider
        output = Output.init(intermediateStopLocations: self.intermediateStopLocationsSubject.asObservable(), pickupLocation: pickupLocationSubject.asObservable(), dropOffLocation: dropOffLocationSubject.asObservable(), vehicleLocation: vehicleLocationSubject.asObservable(), bookingStatus: self.bookingStatusSubject.asObservable(), activityLoader: self.activityLoaderSubject.asObservable(), bookingBtnStatus: self.bookingBtnStatusSubject.asObservable(), userInformationStatus: self.userInformationSubject.asObservable())


    }


    /// hide or show BookingBtn
    ///
    /// - Parameter enabled: is for setting Booking Btn View
    private func bookingBtnStatus(enabled: Bool)
    {
        self.bookingBtnStatusSubject.onNext(enabled)
    }

    /// hide or show the dropoff location, and the pickup
    ///
    /// - Parameter enabled: Bool for status
    private func userInformationStatus(enabled: Bool)
    {
        self.userInformationSubject.onNext(enabled)
    }

    /// this function is for handling Booking Status
    ///
    /// - Parameter statusUpdated: represents one of BookingStatus
    private func handleClosedStatusEvent(statusUpdated: BookingStatus)
    {
        switch statusUpdated {
        case .closed, .disMissed:
            self.bookingStatusSubject.onNext(statusUpdated.description)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.userInformationStatus(enabled: true)
                self.bookingBtnStatus(enabled: false)
                self.bookingStatusSubject.onNext("")
            }
        default:
            self.bookingStatusSubject.onNext(statusUpdated.description)
        }

    }

    /// this for handling error happens when streaming the Events
    private func handleError()
    {
        self.handleClosedStatusEvent(statusUpdated: .disMissed)
    }

    /// this function handle updated location for pickup, dropOff,
    ///
    /// - Parameters:
    ///   - location: this the updated location
    ///   - locationType: the type that will emit its event
    private func handleUpdatedLocation(location: Location, locationType: LocationType)
    {
        switch locationType {
        case .dropoff:
            self.dropOffLocationSubject.onNext(location)
        case .vehicle:
            var currentVehicleLocation = location
            currentVehicleLocation.setBearingAngle(for: self.previousVehicleLocation)
            self.vehicleLocationSubject.onNext(currentVehicleLocation)
            previousVehicleLocation = currentVehicleLocation
        case .pickup:
            self.pickupLocationSubject.onNext(location)
        }
    }

    /// this function for handling intermediatestoplocations updates
    ///
    /// - Parameter locations: list of intermediatestoplocation
    private func handleIntermediateStopLocations(locations: [Location]?)
    {
        self.intermediateStopLocationsSubject.onNext(locations)
    }

    /// this function for handling bookingDetailed information when the booking opend event is opend
    ///
    /// - Parameter bookingInfo: bookingDetailsinformation
    private func handleBookingDetailsInformations(bookingInfo: BookingDetailsInformation)
    {
        self.activityLoaderSubject.onNext(false)
        self.userInformationStatus(enabled: false)
        self.handleUpdatedLocation(location: bookingInfo.dropoffLocation, locationType: .dropoff)
        self.handleUpdatedLocation(location: bookingInfo.pickupLocation, locationType: .pickup)
        self.handleUpdatedLocation(location: bookingInfo.vehicleLocation, locationType: .vehicle)
        self.handleIntermediateStopLocations(locations: bookingInfo.intermediateStopLocations)
        self.handleClosedStatusEvent(statusUpdated: bookingInfo.status)
    }

    /// this function for assign subscriber to the eventDataProviders sequence
    private func handleLiveBookingEvents()
    {
        if let bookingEventsObservable = self.bookingEventsObservable
        {
            bookingEventsObservable
                .subscribe(onNext: { [weak self] (event) in
                    guard let self = self else { return }

                    switch event
                    {
                    case .bookingClosed:
                        self.handleClosedStatusEvent(statusUpdated: BookingStatus.closed)
                    case .bookingOpened(let bookingInfo):
                        self.handleBookingDetailsInformations(bookingInfo: bookingInfo)
                    case .intermediateStopLocationsChanged(let locations):
                        self.handleIntermediateStopLocations(locations: locations)
                    case .statusUpdated(let status):
                        self.handleClosedStatusEvent(statusUpdated: status)
                    case .vehicleLocationUpdated(let location):
                        self.handleUpdatedLocation(location: location, locationType: .vehicle)
                    case .other:
                        self.handleClosedStatusEvent(statusUpdated: BookingStatus.closed)
                    }
                }, onError: { (error) in
                        self.handleError()
                    }, onCompleted: {
                        self.handleClosedStatusEvent(statusUpdated: BookingStatus.closed)
                    }).disposed(by: disposeBag)
        }
    }

    /// this functio is called to start the live events reacking
    func getLiveEvents()
    {
        self.activityLoaderSubject.onNext(true)
        self.bookingBtnStatus(enabled: true)
        self.bookingEventsObservable =
            eventDataProvider
            .execute()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)

    }
}
