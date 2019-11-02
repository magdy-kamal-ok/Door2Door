//
//  MockedSocketManager.swift
//  BookingTests
//
//  Created by mac on 10/12/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift
import NetworkManager

class MockedSocketManager: NetworkProtocol {
    func startConnection(requestComponents: RequstHandlerProtocol) -> Observable<ResultModel>? {
        let bundle = Bundle(for: MockedSocketManager.self)
        let dataPath = bundle.url(forResource: requestComponents.getSocketEndPoint(), withExtension: "json")
        return Observable.create { observer in
            var listData: [Data] = []
            
            do {
                let data = try Data(contentsOf: dataPath!)
                let jsonlist = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                for json in jsonlist
                {
                    
                    let dataObj =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                    listData.append(dataObj)
                    
                }
            } catch {
            
                let customError = ErrorModel(code: LocalError.parsingFailure.errorCode, message: LocalError.parsingFailure.localizedDescription, error: nil)
                observer.onNext(ResultModel.Faliure(customError))
            }
            return Observable<Int>
                .timer(.seconds(2), period: .nanoseconds(10), scheduler: MainScheduler.instance)
                .takeWhile { $0 < listData.count }
                .map { ResultModel.success(listData[$0]) }
                .subscribe(observer)
        }
    }
    
}


