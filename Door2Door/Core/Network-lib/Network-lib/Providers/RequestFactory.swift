//
//  RequestFactory.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

struct RequestFactory: RequstHandlerProtocol {

    
    var endPoint: String
    
    init(endPoint: String)
    {
        self.endPoint = endPoint
    }
    
    func getSocketEndPoint() -> String {
        return self.endPoint
    }
   
}
