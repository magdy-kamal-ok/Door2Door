//
//  VehicleAnnotation.swift
//  Booking
//
//  Created by mac on 10/8/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import MapKit

/// Custom Annotaion For Vehicle Annotaion
class VehicleAnnotation: MKPointAnnotation {
    
    /// refrence for annotaionView to easly update the bearing Angle, and weak for avoiding retain Cycle
    weak var annotationView: VehicleAnnotationView?
    
    var bearing: Double? {
        didSet {
            annotationView?.bearing = bearing
        }
    }
}

/// Custom AnnotationView for Vehicle it contains imageView so i can change the rotaion angle based ong the bearing angle
class VehicleAnnotationView: MKAnnotationView {
    
    private var imageView: UIImageView = {
        let imageView =  UIImageView.init(image: UIImage(named: "vehicle-pin"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    var bearing: Double? {
        didSet {
            imageView.transform = CGAffineTransform.identity.rotated(by: CGFloat(bearing ?? 0))
        }
    }
    
    override var annotation: MKAnnotation? {
        didSet {
            if let vehicleAnnotation = annotation as? VehicleAnnotation {
                vehicleAnnotation.annotationView = self
            }
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupAnnotaionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAnnotaionView()
    }
    
    /// this for seting up the custom Views added to the customVehicleAnnotaionView
    private func setupAnnotaionView() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        if let vehicleAnnotation = annotation as? VehicleAnnotation {
            bearing = vehicleAnnotation.bearing
            vehicleAnnotation.annotationView = self
        }
    }
}
