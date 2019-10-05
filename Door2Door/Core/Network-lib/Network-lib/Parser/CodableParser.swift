//
//  CodableParser.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation


public struct CodableParser: ParserProtocol {

 
    public init() {}

    public func parseData<T: Codable>(data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let item = try decoder.decode(T.self, from: data)
            return item
            
        } catch {
            return nil
        }
    }
    
}
