//
//  IntermediateStopAnnotaion.swift
//  Booking
//
//  Created by mac on 10/9/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import MapKit

class IntermediateStopAnnotaion: MKPointAnnotation {
    
    
}

class IntermediateStopAnnotaionView: MKAnnotationView {
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupAnnotaionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAnnotaionView()
    }
    
    private func setupAnnotaionView() {
        self.image = UIImage.init(named: "stop-pin.png")
    }
}
