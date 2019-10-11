//
//  BookingEvent.swift
//  Booking
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

enum BookingEvent {
    case bookingOpened(BookingDetailsInformation)
    case vehicleLocationUpdated(Location)
    case statusUpdated(BookingStatus)
    case intermediateStopLocationsChanged([Location])
    case bookingClosed
    case other
}

extension BookingEvent: Codable {
    func encode(to encoder: Encoder) throws {
        
    }
    
    
    enum CodingKeys: String, CodingKey {
        case event
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let eventName = try container.decode(String.self, forKey: .event)
        
        switch eventName {
        case "bookingOpened":
            self = .bookingOpened(try container.decode(BookingDetailsInformation.self, forKey: .data))
        case "vehicleLocationUpdated":
            self = .vehicleLocationUpdated(try container.decode(Location.self, forKey: .data))
        case "statusUpdated":
            self = .statusUpdated(try container.decode(BookingStatus.self, forKey: .data))
        case "intermediateStopLocationsChanged":
            self = .intermediateStopLocationsChanged(try container.decode([Location].self, forKey: .data))
        case "bookingClosed":
            self = .bookingClosed
        default:
            self = .other
        }
    }
}
