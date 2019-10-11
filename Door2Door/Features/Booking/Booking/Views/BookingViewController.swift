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
   
    @IBOutlet weak var userLocationView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var startBookingBtn: UIButton!
    @IBOutlet weak var dropoffAddressLbl: UILabel!
    @IBOutlet weak var pickupAddressLbl: UILabel!
    @IBOutlet weak var statusValueLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var bookingViewModel: BookingViewModel!
    let disposeBag = DisposeBag()
    private var vehicleAnnotation = VehicleAnnotation()
    private var pickupAnnotation = PickupAnnotaion()
    private var dropOffAnnotation = DropoffAnnotaion()
    private var intermediateStopsAnnotations = [IntermediateStopAnnotaion]()

    init(with viewModel: BookingViewModel) {
        let bundel = Bundle(for: BookingViewController.self)
        super.init(nibName: "BookingViewController", bundle: bundel)
        self.bookingViewModel = viewModel


    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMapView()
        subscribeToBookingEvents()

    }
    
    private func bindStatusView()
    {
        self.bookingViewModel
            .output
            .bookingStatus
            .map{$0.isEmpty}
            .bind(to: self.statusView.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    
    private func bindClosedConnectionAndDismissed()
    {
        self.bookingViewModel
            .output
            .bookingStatus
            .map{$0.isEmpty}
            .subscribe(onNext: { [weak self](status) in
                guard let self = self else {return}
                if status
                {
                    self.removeAllAnnotations()
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func bindBookingEventStatus()
    {
        self.bookingViewModel
            .output
            .bookingStatus
            .bind(to: self.statusValueLbl.rx.text)
            .disposed(by: self.disposeBag)
    }
    private func bindBookingBtnStatus()
    {
        self.bookingViewModel
            .output
            .bookingBtnStatus
            .bind(to: self.startBookingBtn.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    private func bindPickupLocationAddress()
    {
        self.bookingViewModel
            .output
            .pickupLocation
            .map { $0?.address }
            .bind(to: self.pickupAddressLbl.rx.text)
            .disposed(by: self.disposeBag)
    }
    private func bindDropOffLocationAddress()
    {
        self.bookingViewModel
            .output
            .dropOffLocation
            .map { $0?.address }
            .bind(to: self.dropoffAddressLbl.rx.text)
            .disposed(by: self.disposeBag)
    }
    private func bindActivityLoaderStatus()
    {
        self.bookingViewModel
            .output
            .activityLoader
            .bind(to: self.activityLoader.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
    private func bindUserLocationViewStatus()
    {
        self.bookingViewModel
            .output
            .userInformationStatus
            .bind(to: self.userLocationView.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    private func bindIntermediateStopLocations()
    {
        self.bookingViewModel
            .output
            .intermediateStopLocations
            .subscribe(onNext: { [weak self] (intermediateStopLocations) in
                guard let self = self else { return }
                self.mapView.removeAnnotations(self.intermediateStopsAnnotations)
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
                UIView.animate(withDuration: 1.5, animations: {
                    [weak self] in
                    guard let self = self else{return}
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
    func setupMapView() {
        mapView.register(PickupAnnotaionView.self)
        mapView.register(DropoffAnnotaionView.self)
        mapView.register(IntermediateStopAnnotaionView.self)
        mapView.register(VehicleAnnotationView.self)
        mapView.delegate = self
    }


    @IBAction func startBookingClick(_ sender: UIButton)
    {
        self.bookingViewModel.getLiveEvents()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
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
    
    func removeAllAnnotations() {
        let annotations = mapView.annotations.filter {
            $0 !== self.pickupAnnotation
        }
        mapView.removeAnnotations(annotations)
    }
}
