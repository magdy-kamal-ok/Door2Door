//
//  ErrorTypes.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

enum LocalError: Error {
    
    case connectionClosed
    case timeOut
    case parsingFailure
    var localizedDescription: String {
        switch self {
        case .connectionClosed: return "Connection Closed"
        case .timeOut: return "Time out"
        case .parsingFailure: return "Parsing Failure"
        }
    }
    var errorCode:Int
    {
        switch self {
        case .connectionClosed: return LocalErrorCode.connectionClosed.rawValue
        case .timeOut: return LocalErrorCode.timeOut.rawValue
        case .parsingFailure: return LocalErrorCode.parsingFailure.rawValue
        }
    }
}

enum LocalErrorCode: Int {
    
    case connectionClosed = 5000
    case timeOut = 5001
    case parsingFailure = 5002
    
}
