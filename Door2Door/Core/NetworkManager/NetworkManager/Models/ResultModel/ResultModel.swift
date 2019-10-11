//
//  ResultModel.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

public enum ResultModel<T:AnyObject> {
    case success(T:Data)
    case Faliure (ErrorModel)
}
