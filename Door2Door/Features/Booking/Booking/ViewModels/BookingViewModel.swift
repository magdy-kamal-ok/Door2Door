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

enum LocationType
{
    case vehicle
    case dropoff
    case pickup
}
class BookingViewModel {
    private let requestHandler = RequestFactory.init(endPoint: BookingConstants.bookingEndPoint)
    private let eventDataProvider: EventDataProvider<BookingEvent>!
    let disposeBag = DisposeBag()

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

    init() {

        eventDataProvider = EventDataProvider.init(requestHandler: requestHandler)
        output = Output.init(intermediateStopLocations: self.intermediateStopLocationsSubject.asObservable(), pickupLocation: pickupLocationSubject.asObservable(), dropOffLocation: dropOffLocationSubject.asObservable(), vehicleLocation: vehicleLocationSubject.asObservable(), bookingStatus: self.bookingStatusSubject.asObservable(), activityLoader: self.activityLoaderSubject.asObservable(), bookingBtnStatus: self.bookingBtnStatusSubject.asObservable(), userInformationStatus: self.userInformationSubject.asObservable())

    }
    

    private func bookingBtnStatus(enabled: Bool)
    {
        self.bookingBtnStatusSubject.onNext(enabled)
    }
    private func userInformationStatus(enabled: Bool)
    {
        self.userInformationSubject.onNext(enabled)
    }
    
    private func handleClosedStatusEvent(statusUpdated: BookingStatus)
    {
        switch statusUpdated {
        case .closed, .disMissed:
            self.bookingStatusSubject.onNext(statusUpdated.description)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.userInformationStatus(enabled: true)
                self.bookingBtnStatus(enabled: false)
                self.bookingStatusSubject.onNext("")
            }
        default:
            self.bookingStatusSubject.onNext(statusUpdated.description)
        }
        
    }
    private func handleError(error: Error)
    {
        let error = error as! ErrorModel
        self.handleClosedStatusEvent(statusUpdated: .disMissed)
        
        
        
    }
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

    private func handleIntermediateStopLocations(locations: [Location]?)
    {
        self.intermediateStopLocationsSubject.onNext(locations)
    }

    /// <#Description#>
    ///
    /// - Parameter bookingInfo: <#bookingInfo description#>
    private func handleBookingDetailsInformations(bookingInfo: BookingDetailsInformation)
    {
        self.userInformationStatus(enabled: false)
        self.handleUpdatedLocation(location: bookingInfo.dropoffLocation, locationType: .dropoff)
        self.handleUpdatedLocation(location: bookingInfo.pickupLocation, locationType: .pickup)
        self.handleUpdatedLocation(location: bookingInfo.vehicleLocation, locationType: .vehicle)
        self.handleIntermediateStopLocations(locations: bookingInfo.intermediateStopLocations)
        self.handleClosedStatusEvent(statusUpdated: bookingInfo.status)
    }
    func getLiveEvents()
    {
        self.activityLoaderSubject.onNext(true)
        self.bookingBtnStatus(enabled: true)
        eventDataProvider
            .execute()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (event) in
                guard let self = self else { return }
                self.activityLoaderSubject.onNext(false)
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
                    self.handleError(error: error)
            }, onCompleted: {
                self.handleClosedStatusEvent(statusUpdated: BookingStatus.closed)
            }).disposed(by: disposeBag)
    }
}
