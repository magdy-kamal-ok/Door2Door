//
//  StarScreamManager.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift
import Starscream

public class StarScreamManager: NetworkProtocol {
    
    public init() {}
    
    public func startConnection<T>(requestComponents: RequstHandlerProtocol) -> Observable<ResultModel<T>>? where T : AnyObject {
        return Observable.create { [weak self] observer in
            guard self != nil else {
                return Disposables.create {}
            }
            
            let socket = WebSocket(url: URL(string: requestComponents.getSocketEndPoint())!)
            
            // When the socket is disconnected
            socket.onDisconnect = { error in
                if let error = error {
                    // If it's because of an error then forward that to the observer
                    observer.onError(error)
                } else {
                    // Else the connection has been completed successfully
                    observer.onCompleted()
                }
            }
            
            // Whenever text is received
            socket.onText = { message in
                // convert it to data
                guard let data = message.data(using: .utf16) else { return }
                do {
                    observer.onNext(ResultModel.success(T: data))
                    
                } catch {
                    // Else send the parsing error to the observer
                    let customError = ErrorModel(code:  LocalError.parsingFailure.errorCode, message: LocalError.parsingFailure.localizedDescription, error: nil, additionalInfo: nil)
                    observer.onNext(ResultModel.Faliure(customError))
                }
            }
            
            // Whenever data is received
            socket.onData = { data in
                observer.onNext(ResultModel.success(T: data))
            }
            
            // connect to the socket
            socket.connect()

            return Disposables.create {
                // dispose of the connection
                socket.disconnect()
            }
        }
    }
    
    
}


