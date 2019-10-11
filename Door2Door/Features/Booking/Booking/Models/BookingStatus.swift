//
//  BookingStatus.swift
//  Booking
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation


enum BookingStatus: String, Decodable {
    case waitingForPickup
    case inVehicle
    case droppedOff
    case closed
    case disMissed
}

extension BookingStatus {
    var description: String {
        switch self {
        case .waitingForPickup:
            return "Waiting for Pickup"
        case .inVehicle:
            return "In Vehicle"
        case .droppedOff:
            return "Dropped Off"
        case .closed:
            return "Booking Closed"
        case .disMissed:
            return "Trip Missed"
        }
    }
}
