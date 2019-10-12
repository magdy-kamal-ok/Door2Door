//
//  EventDataProvider.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift

public class EventDataProvider <R:Codable>{
    
    var requestHandler: RequstHandlerProtocol!
    var socketManager: NetworkProtocol!
    var parser: ParserProtocol!
    let bag = DisposeBag()

    
    public init(requestHandler: RequstHandlerProtocol, socketManager: NetworkProtocol = StarScreamManager(), parser: ParserProtocol = CodableParser())
    {
        self.socketManager = socketManager
        self.requestHandler = requestHandler
        self.parser = parser
        
    }
    
    
    public func execute()->Observable<R>
    {
                
        return Observable.create{ [weak self] observer in
            guard let self = self else { return Disposables.create {} }
            
            if let observable:Observable<ResultModel<AnyObject>> = self.startConnection(requestComponents: self.requestHandler)
            {
                observable.subscribe({ (subObj) in
                    
                    switch subObj
                    {
                    case .next(let responseData):
                        let tupleResult = self.handleResult(response: responseData)
                        if let error = tupleResult.1
                        {
                            observer.onError(error)
                        }
                        if let response = tupleResult.0
                        {
                            observer.onNext(response)
                        }
                    case .error(let error):
                        let error = self.handleError(error: error)
                        observer.onError(error)
                        
                    case .completed:
                        observer.onCompleted()
                    }
                    
                }).disposed(by: self.bag)
            }
            return Disposables.create {
                
            }
        }
    }
    
    private func handleResult(response:ResultModel<AnyObject>) -> (R? ,Error?)
    {
        switch response {
        case .Faliure(let error):
            return (nil, self.handleError(error: error))
        case .success(T: let data):
            return self.handleSuccessData(data: data)
        }
    }
    
    private func handleSuccessData(data:Data) -> (R? ,Error?)
    {
        if let parsedObject:R = self.parser.parseData(data: data)
        {
            return (parsedObject, nil)
        }
        else
        {
            var error = ErrorModel.init()
            error.code = LocalError.parsingFailure.errorCode
            error.message = LocalError.parsingFailure.localizedDescription
            let returnError = self.handleError(error: error)
            return (nil, returnError)
        }
        
    }
    
    private func handleError(error:Error) -> Error
    {
        return error
    }
}
extension EventDataProvider: NetworkProtocol
{
    public func startConnection<T>(requestComponents: RequstHandlerProtocol) -> Observable<ResultModel<T>>? where T : AnyObject {
        if let objObserve:Observable<ResultModel<T>> = socketManager.startConnection(requestComponents: self.requestHandler)
        {
            return objObserve
        }
        return Observable.empty()
    }
    
    
}
