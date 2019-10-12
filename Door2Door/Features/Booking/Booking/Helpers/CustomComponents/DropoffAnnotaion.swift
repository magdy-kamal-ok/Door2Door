//
//  DropoffAnnotaion.swift
//  Booking
//
//  Created by mac on 10/9/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import MapKit

class DropoffAnnotaion: MKPointAnnotation {
    
    
}
/// Custom AnnotaionView For DropoffAnnotaion
class DropoffAnnotaionView: MKAnnotationView {
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupAnnotaionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAnnotaionView()
    }
    
    private func setupAnnotaionView() {
        image = UIImage.init(named: "dropoff-pin.png")
    }
}
