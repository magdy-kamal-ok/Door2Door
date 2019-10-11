//
//  DoubleExtension.swift
//  Booking
//
//  Created by mac on 10/9/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

extension Double {

    var radians: Double{
        get
        {
            return self * .pi / 180.0
        }
    }
    
    var degrees: Double{
        get
        {
            return self * .pi / 180.0
        }
    }
}
