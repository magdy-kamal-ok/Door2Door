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

/// StarScreamManager is responsible for connecting to wesockets
/// and emit the response data to the above layer as Data in case of success
/// and Error in case of unsuccessful data recieved or connection error

public class StarScreamManager: NetworkProtocol {

    public init() { }

    public func startConnection(requestComponents: RequstHandlerProtocol) -> Observable<ResultModel>? {
        return Observable.create { [weak self] observer in
            guard let _ = self else {
                return Disposables.create { }
            }

            let socket = WebSocket(url: URL(string: requestComponents.getSocketEndPoint())!)
            // this closure in case of Disconnection
            socket.onDisconnect = { (error: Error?) in
                if let error = error as? WSError {
                    var customError: ErrorModel?
                    if error.code == Int(CloseCode.normal.rawValue)
                    {
                        observer.onCompleted()
                    }
                    else
                    {
                        customError = ErrorModel(code: error.code, message: error.message, error: error.localizedDescription)
                        observer.onNext(ResultModel.Faliure(customError!))

                    }
                } else {
                    let customError = ErrorModel(code: LocalError.connectionClosed.errorCode, message: LocalError.connectionClosed.localizedDescription, error: nil)
                    observer.onNext(ResultModel.Faliure(customError))
                }
            }
            // this closure in case of recieving Data as Text
            socket.onText = { message in
                guard let data = message.data(using: .utf16) else {
                    let customError = ErrorModel(code: LocalError.parsingFailure.errorCode, message: LocalError.parsingFailure.localizedDescription, error: nil)
                    observer.onNext(ResultModel.Faliure(customError))
                    return
                }
                observer.onNext(ResultModel.success(data))
            }
            // this closure in case of recieving Data as Data
            socket.onData = { data in
                observer.onNext(ResultModel.success(data))
            }
            // start connection
            socket.connect()

            return Disposables.create {
                socket.disconnect()
            }
        }
    }


}


