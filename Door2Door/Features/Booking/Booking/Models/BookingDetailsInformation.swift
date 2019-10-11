//
//  BookingDetailsInformation.swift
//  Booking
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation
struct BookingDetailsInformation: Decodable {
    
    let status: BookingStatus
    let vehicleLocation: Location
    let pickupLocation: Location
    let dropoffLocation: Location
    let intermediateStopLocations: [Location]
}
