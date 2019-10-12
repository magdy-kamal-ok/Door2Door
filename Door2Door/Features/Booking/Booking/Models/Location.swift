//
//  Location.swift
//  Booking
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation


/// this this location for each type of locations, like vehicle, dropoff, pickup, and Intermediate Locations
struct Location: Decodable {

    enum CodingKeys: String, CodingKey {
        case longitude = "lng"
        case latitude = "lat"
        case address
    }

    let address: String?
    let longitude: Double
    let latitude: Double

    /// this the bearing Angle for vehicle
    var bearing: Double?


    /// this func to calculte the bearing angle between 2 locations, and this calculattion method from https://stackoverflow.com/a/31817498/10871790
    ///
    /// - Parameter prevLocation: it takes the previous location, and calculate the bearing Angle besides the current location object
    mutating func setBearingAngle(for prevLocation: Location?) {
        guard let prevLocation = prevLocation else {
            bearing = nil
            return
        }

        let lat1 = prevLocation.latitude.radians
        let lon1 = prevLocation.longitude.radians

        let lat2 = self.latitude.radians
        let lon2 = self.longitude.radians
        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        bearing = atan2(y, x)

    }
}
