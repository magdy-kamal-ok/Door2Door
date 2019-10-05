//
//  ParserProtocol.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

public protocol ParserProtocol {
    
    func parseData<T:Codable>(data:Data) -> T?
}

