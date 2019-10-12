//
//  BookingViewController.swift
//  Booking
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit
class BookingViewController: UIViewController {
    // Mark: - Outlets
    @IBOutlet weak var userLocationView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var startBookingBtn: UIButton!
    @IBOutlet weak var dropoffAddressLbl: UILabel!
    @IBOutlet weak var pickupAddressLbl: UILabel!
    @IBOutlet weak var statusValueLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    // Mark: - private variables
    private var bookingViewModel: BookingViewModel!
    private let disposeBag = DisposeBag()
    private var vehicleAnnotation = VehicleAnnotation()
    private var pickupAnnotation = PickupAnnotaion()
    private var dropOffAnnotation = DropoffAnnotaion()
    private var intermediateStopsAnnotations = [IntermediateStopAnnotaion]()

    /// the Booking ViewController initializer, expecting to inject the ViewModel
    ///
    /// - Parameter viewModel: the viewModel that contains our business logic for ViewController
    init(with viewModel: BookingViewModel) {
        let bundel = Bundle(for: BookingViewController.self)
        super.init(nibName: "BookingViewController", bundle: bundel)
        self.bookingViewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMapView()
        self.subscribeToBookingEvents()
    }

    /// this function is to show or hide booking status view
    private func bindStatusView()
    {
        self.bookingViewModel
            .output
            .bookingStatus
            .map { $0.isEmpty }
            .bind(to: self.statusView.rx.isHidden)
            .disposed(by: self.disposeBag)
    }

    /// this function is to reset All Views in case received dismissed, or closed, and depends on reciving Empty String
    private func bindClosedConnectionAndDismissed()
    {
        self.bookingViewModel
            .output
            .bookingStatus
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self](status) in
                guard let self = self else { return }
                if status
                {
                    self.removeAllAnnotations()
                }
            }).disposed(by: self.disposeBag)
    }

    /// this is to bind booking status value to the staus label
    private func bindBookingEventStatus()
    {
        self.bookingViewModel
            .output
            .bookingStatus
            .bind(to: self.statusValueLbl.rx.text)
            .disposed(by: self.disposeBag)
    }

    /// this function is to show or hide booking status Btn
    private func bindBookingBtnStatus()
    {
        self.bookingViewModel
            .output
            .bookingBtnStatus
            .bind(to: self.startBookingBtn.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    /// this is to bind pickupLocationAddress to pickup label
    private func bindPickupLocationAddress()
    {
        self.bookingViewModel
            .output
            .pickupLocation
            .map { $0?.address }
            .bind(to: self.pickupAddressLbl.rx.text)
            .disposed(by: self.disposeBag)
    }
    /// this is to bind dropoffLocationAddress to dropoff label
    private func bindDropOffLocationAddress()
    {
        self.bookingViewModel
            .output
            .dropOffLocation
            .map { $0?.address }
            .bind(to: self.dropoffAddressLbl.rx.text)
            .disposed(by: self.disposeBag)
    }
    /// this function is to show or hide activityLoader
    private func bindActivityLoaderStatus()
    {
        self.bookingViewModel
            .output
            .activityLoader
            .bind(to: self.activityLoader.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
    /// this function is to show or hide user dropoff, pickup locations labels
    private func bindUserLocationViewStatus()
    {
        self.bookingViewModel
            .output
            .userInformationStatus
            .bind(to: self.userLocationView.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    /// this for binding IntermediateStopLocations to annotaions
    private func bindIntermediateStopLocations()
    {
        self.bookingViewModel
            .output
            .intermediateStopLocations
            .subscribe(onNext: { [weak self] (intermediateStopLocations) in
                guard let self = self else { return }
                if let intermediateStopLocations = intermediateStopLocations
                {
                    self.intermediateStopsAnnotations = intermediateStopLocations.map { location in
                        let annotation = IntermediateStopAnnotaion()
                        annotation.coordinate = CLLocationCoordinate2D.init(latitude: location.latitude, longitude: location.longitude)
                        annotation.title = location.address
                        return annotation
                    }
                    self.mapView.addAnnotations(self.intermediateStopsAnnotations)
                }
            })
            .disposed(by: disposeBag)
    }
    /// this for binding VehicleLocation to annotaion
    private func bindVehicleLocation()
    {
        self.bookingViewModel
            .output
            .vehicleLocation
            .subscribe(onNext: { [weak self] (location) in
                guard let self = self else { return }
                self.handleUpdatedLocation(location: location, type: .vehicle)
            })
            .disposed(by: disposeBag)
    }
    /// this for binding PickupLocation to annotaion
    private func bindPickupLocation()
    {

        self.bookingViewModel
            .output
            .pickupLocation
            .subscribe(onNext: { [weak self] (location) in
                guard let self = self else { return }
                self.handleUpdatedLocation(location: location, type: .pickup)
            })
            .disposed(by: disposeBag)
    }

    /// this for binding DropOffLocation to annotaion
    private func bindDropOffLocation()
    {
        self.bookingViewModel
            .output
            .dropOffLocation
            .subscribe(onNext: { [weak self] (location) in
                guard let self = self else { return }
                self.handleUpdatedLocation(location: location, type: .dropoff)
            })
            .disposed(by: disposeBag)
    }

    /// this function is to start all binding needed
    private func subscribeToBookingEvents()
    {
        self.bindBookingEventStatus()
        self.bindPickupLocation()
        self.bindDropOffLocation()
        self.bindIntermediateStopLocations()
        self.bindVehicleLocation()
        self.bindDropOffLocationAddress()
        self.bindPickupLocationAddress()
        self.bindActivityLoaderStatus()
        self.bindBookingBtnStatus()
        self.bindStatusView()
        self.bindClosedConnectionAndDismissed()
        self.bindUserLocationViewStatus()
    }

    /// this func is to add locations on map as annnotaion based on type provided
    ///
    /// - Parameters:
    ///   - location: location of the annotaion
    ///   - type: type of the location to be added to annotaion
    private func handleUpdatedLocation(location: Location?, type: LocationType)
    {
        switch type {
        case .dropoff:
            if let dropoffLocation = location {
                dropOffAnnotation.coordinate = CLLocationCoordinate2D.init(latitude: dropoffLocation.latitude, longitude: dropoffLocation.longitude)
                dropOffAnnotation.title = dropoffLocation.address
                mapView?.addAnnotation(dropOffAnnotation)
            } else {
                mapView?.removeAnnotation(dropOffAnnotation)
            }

        case .vehicle:
            if let vehicleLocation = location {
                mapView?.addAnnotation(vehicleAnnotation)
                UIView.animate(withDuration: 2.0, animations: {
                    [weak self] in
                    guard let self = self else { return }
                    self.vehicleAnnotation.coordinate = CLLocationCoordinate2D.init(latitude: vehicleLocation.latitude, longitude: vehicleLocation.longitude)
                    self.vehicleAnnotation.bearing = vehicleLocation.bearing
                    self.mapView.adjustMapZoomToAnnotaionsLocations(animated: true)
                })
            } else {
                mapView?.removeAnnotation(vehicleAnnotation)
            }
        case .pickup:
            if let pickupLocation = location {
                pickupAnnotation.coordinate = CLLocationCoordinate2D.init(latitude: pickupLocation.latitude, longitude: pickupLocation.longitude)
                pickupAnnotation.title = pickupLocation.address
                mapView?.addAnnotation(pickupAnnotation)
            } else {
                mapView?.removeAnnotation(pickupAnnotation)
            }
        }
        mapView?.adjustMapZoomToAnnotaionsLocations(animated: false)


    }

    /// setup MapView Annotaions and delegate
    func setupMapView() {
        mapView.register(PickupAnnotaionView.self)
        mapView.register(DropoffAnnotaionView.self)
        mapView.register(IntermediateStopAnnotaionView.self)
        mapView.register(VehicleAnnotationView.self)
        mapView.delegate = self
    }

    ///  this functiontriggered when the status btn is touch up inside
    @IBAction func startBookingClick(_ sender: UIButton)
    {
        self.bookingViewModel.getLiveEvents()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - this for MapKit delegate to set annotaionview per specified Annotaion
extension BookingViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let annotationView: MKAnnotationView
        if annotation === vehicleAnnotation {
            let view: VehicleAnnotationView = mapView.dequeueReusableAnnotationView(for: annotation)
            annotationView = view
        } else if annotation === pickupAnnotation {
            let view: PickupAnnotaionView = mapView.dequeueReusableAnnotationView(for: annotation)
            annotationView = view
        } else if annotation === dropOffAnnotation {
            let view: DropoffAnnotaionView = mapView.dequeueReusableAnnotationView(for: annotation)
            annotationView = view
        } else {
            let view: IntermediateStopAnnotaionView = mapView.dequeueReusableAnnotationView(for: annotation)
            annotationView = view
            annotationView.canShowCallout = true
        }
        return annotationView
    }

    /// remove all annotaions except user pickup Location
    func removeAllAnnotations() {
        let annotations = mapView.annotations.filter {
            $0 !== self.pickupAnnotation
        }
        mapView.removeAnnotations(annotations)
    }
}
