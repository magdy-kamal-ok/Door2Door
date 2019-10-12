//
//  ErrorModel.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

/// this is the Local Error for Current Network Manager

public struct ErrorModel: Error {
    var code: Int? // http status
    var message: String?
    var error: String?

    /// ErrorModel Constructor
    ///
    /// - Parameters:
    ///   - code: error code that describe this error
    ///   - message: the error message that will appear in ui component in case needed
    ///   - error: the error that describe why error happens
    public init(code: Int?, message: String?, error: String?)
    {
        self.code = code
        self.message = message
        self.error = error
    }

    public init()
    {
        self.init(code: nil, message: nil, error: nil)
    }
}
