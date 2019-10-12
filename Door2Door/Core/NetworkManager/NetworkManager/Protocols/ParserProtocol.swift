//
//  ParserProtocol.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation

/// Parser Protocol is made in case of using different Parser needed
/// but in our case we will use Codable for now
/// it is made for future extension
public protocol ParserProtocol {

    func parseData<T:Codable>(data: Data) -> T?
}

