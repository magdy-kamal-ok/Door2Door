//
//  BookingBuilder.swift
//  Booking
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import UIKit
import NetworkManager

/// This if the BookingBuilder for creating the BookingViewController, and the BookingViewModel
public struct BookingBuilder: BuilderProtocol {

    /// this function is to generate BookingViewController
    ///
    /// - Returns: return ViewController of type BookingViewController
    public static func viewController() -> UIViewController {
        let requestHandler = RequestFactory.init(endPoint: BookingConstants.bookingEndPoint)
        let eventDataProvider: EventDataProvider<BookingEvent> = EventDataProvider.init(requestHandler: requestHandler)

        let bookingViewModel = BookingViewModel(eventDataProvider: eventDataProvider)
        let viewController = BookingViewController(with: bookingViewModel)
        return viewController
    }
}
public protocol BuilderProtocol {
    static func viewController() -> UIViewController
}
