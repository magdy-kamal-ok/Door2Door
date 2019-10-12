//
//  PickupAnnotaion.swift
//  Booking
//
//  Created by mac on 10/8/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import MapKit
/// Custom Annotaion For PickupAnnotaion and it is made for fusture usage if needed to add any properties in Future
class PickupAnnotaion: MKPointAnnotation {
    
    
}
/// Custom AnnotaionView For PickupAnnotaion
class PickupAnnotaionView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupAnnotaionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAnnotaionView()
    }
    
    private func setupAnnotaionView() {
        image = UIImage.init(named: "pickup-pin.png")
    }
}
