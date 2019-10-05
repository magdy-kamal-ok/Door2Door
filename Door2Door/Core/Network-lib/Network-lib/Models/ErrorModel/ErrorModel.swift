//
//  ErrorModel.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

public struct ErrorModel: Error {
    var code: Int? // http status
    var message: String?
    var error: String?
    var additionalInfo: [String: String]?
}
