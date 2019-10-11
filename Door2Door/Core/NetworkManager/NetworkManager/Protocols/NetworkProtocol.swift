//
//  NetworkProtocol.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift

public protocol NetworkProtocol {
    
    func startConnection<T>(requestComponents: RequstHandlerProtocol) -> Observable<ResultModel<T>>?
    
}
