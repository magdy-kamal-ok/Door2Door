//
//  ResultModel.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

/// ResultModel is the enum used to describe result returned from socket Events
///
/// - success: represents the data successful recieved
/// - Faliure: represents the error in case of any error happens
public enum ResultModel {
    case success(Data)
    case Faliure (ErrorModel)
}
