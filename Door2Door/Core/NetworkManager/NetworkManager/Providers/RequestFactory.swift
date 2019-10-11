//
//  RequestFactory.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

public struct RequestFactory: RequstHandlerProtocol {

    
    var endPoint: String
    
    public init(endPoint: String)
    {
        self.endPoint = endPoint
    }
    
    public func getSocketEndPoint() -> String {
        return self.endPoint
    }
   
}
