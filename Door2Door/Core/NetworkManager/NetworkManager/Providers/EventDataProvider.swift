//
//  EventDataProvider.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift

/// EventDataProvider is layer between which handle the result that recived by socket manager and pass it to the parser to parse it, then pass it to its above layer
/// R represents the data need to be parsed to and our case now must be Codable
public class EventDataProvider <R:Codable> {

    var requestHandler: RequstHandlerProtocol!
    var socketManager: NetworkProtocol!
    var parser: ParserProtocol!
    let bag = DisposeBag()


    /// initializer for EventDataProvider
    ///
    /// - Parameters:
    ///   - requestHandler: represnts any object, or struct that conforms to RequstHandlerProtocol
    ///   - socketManager: represnts any socket manager that conforms to NetworkProtocol
    ///   - parser: represnts parser CodableParser For now
    public init(requestHandler: RequstHandlerProtocol, socketManager: NetworkProtocol = StarScreamManager(), parser: ParserProtocol = CodableParser())
    {
        self.socketManager = socketManager
        self.requestHandler = requestHandler
        self.parser = parser

    }

    /// this func is responsible for observing and start parser
    ///
    /// - Parameter observer: observer represents any observer i want to emits result to it
    private func startObservering(observer: AnyObserver<R>)
    {
        if let observable: Observable<ResultModel> = self.startConnection(requestComponents: self.requestHandler)
        {
            observable.asObservable().subscribe({ (subObj) in

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
    }

    /// execute is the main function needed for observing the data
    ///
    /// - Returns: it returns Observable<R> R is the Type expected to be waiting for as result
    public func execute() -> Observable<R>
    {

        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create { } }
            self.startObservering(observer: observer)
            return Disposables.create {

            }
        }
    }

/// this function is to handle ResultModel Cases
///
/// - Parameter response: is of type Result Model
/// - Returns: it reeturn Tuple of ExpectedData:R, or error in case of there is one
    private func handleResult(response: ResultModel) -> (R?, Error?)
    {
        switch response {
        case .Faliure(let error):
            return (nil, self.handleError(error: error))
        case .success(T: let data):
            return self.handleSuccessData(data: data)
        }
    }

/// this function is responsible for calling the parsing Method of the parser
///
/// - Parameter data: is the data recieved for the socket manager as response
/// - Returns: it return Tuple of ExpectedData:R, or error in case of there is one
    private func handleSuccessData(data: Data) -> (R?, Error?)
    {
        if let parsedObject: R = self.parser.parseData(data: data)
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

/// this function is for handling error if there is some error does not need to be emited to the above layer
///
/// - Parameter error: it takes error as paramerter
/// - Returns: it returns error it might change the error message or any thing if ther is some Special Error
    private func handleError(error: Error) -> Error
    {
        return error
    }
}

// MARK: - this conform is to make any one use the EventDataProvider with different Socket manager to Must Conform to NetworkProtocol
extension EventDataProvider: NetworkProtocol
{

    public func startConnection(requestComponents: RequstHandlerProtocol) -> Observable<ResultModel>? {
        if let objObserve: Observable<ResultModel> = socketManager.startConnection(requestComponents: self.requestHandler)
        {
            return objObserve
        }
        return Observable.empty()
    }


}
