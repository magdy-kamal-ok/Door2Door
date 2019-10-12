//
//  DoubleExtension.swift
//  Booking
//
//  Created by mac on 10/9/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

extension Double {

    /// convert degree to radians
    var radians: Double {
        get
        {
            return self * .pi / 180.0
        }
    }
    /// convert radians to degree
    var degrees: Double {
        get
        {
            return self * 180 / .pi
        }
    }
}
