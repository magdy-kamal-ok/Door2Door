//
//  VehicleAnnotation.swift
//  Booking
//
//  Created by mac on 10/8/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import MapKit

class VehicleAnnotation: MKPointAnnotation {
    
    weak var annotationView: VehicleAnnotationView?
    
    var bearing: Double? {
        didSet {
            annotationView?.bearing = bearing
        }
    }
}

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
