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

    public init() { }

    public func startConnection<T>(requestComponents: RequstHandlerProtocol) -> Observable<ResultModel<T>>? where T: AnyObject {
        return Observable.create { [weak self] observer in
            guard let _ = self else {
                return Disposables.create { }
            }

            let socket = WebSocket(url: URL(string: requestComponents.getSocketEndPoint())!)

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

            socket.onText = { message in
                guard let data = message.data(using: .utf16) else {
                    let customError = ErrorModel(code: LocalError.parsingFailure.errorCode, message: LocalError.parsingFailure.localizedDescription, error: nil)
                    observer.onNext(ResultModel.Faliure(customError))
                    return
                }
                observer.onNext(ResultModel.success(T: data))
            }

            socket.onData = { data in
                observer.onNext(ResultModel.success(T: data))
            }

            socket.connect()

            return Disposables.create {
                socket.disconnect()
            }
        }
    }


}


