//
//  BookingStatus.swift
//  Booking
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation


/// this Enum for All BookingStatuses
///
/// - waitingForPickup: it is when waiting until have the ride
/// - inVehicle: it represents that now the status is inside the car
/// - droppedOff: it represents the destination dropoff status
/// - closed: it represents that connection closed
/// - disMissed: it represents that some error happens, and why the trip is dismissed and you can try again
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
