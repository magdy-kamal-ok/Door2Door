//
//  NetworkProtocol.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift

/// the NetworkProtocol made for any usage for socket managers all what you need to dao is to conform to this protocol and the above layer will not affeced with any change incase of changing StarScream to something like socket.io-client-swift or SwiftWebSocket..etc
public protocol NetworkProtocol {

    /// function needed to be immplemrented in case of using another SocketManager
    ///
    /// - Parameter requestComponents: the data needed for the socket manger to connect to end point but until now all what we need is the EndPoint
    /// - Returns: the expected return value is Observable of ResultModel enum T represents 2 cases one for Data and the other is the  ErrorModel
    func startConnection<T>(requestComponents: RequstHandlerProtocol) -> Observable<ResultModel<T>>?

}
