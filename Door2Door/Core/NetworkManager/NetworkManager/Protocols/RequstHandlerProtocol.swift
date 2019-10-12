//
//  RequstHandlerProtocol.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

/// for request handler components in case of endPoint, data to be sent to server, or any thing need to set for socket manager
public protocol RequstHandlerProtocol {

    func getSocketEndPoint() -> String

}
