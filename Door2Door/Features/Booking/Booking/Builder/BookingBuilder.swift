//
//  BookingBuilder.swift
//  Booking
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import UIKit

public struct BookingBuilder {
    
    public static func viewController() -> UIViewController {
        let bookingViewModel = BookingViewModel()
        let viewController = BookingViewController(with: bookingViewModel)
        return viewController
    }
}
