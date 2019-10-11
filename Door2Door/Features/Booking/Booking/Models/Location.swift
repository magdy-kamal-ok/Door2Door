//
//  Location.swift
//  Booking
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

struct Location: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lng"
        case latitude = "lat"
        case address
    }
    
    let address: String?
    let longitude: Double
    let latitude: Double
    var bearing: Double?
    
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
