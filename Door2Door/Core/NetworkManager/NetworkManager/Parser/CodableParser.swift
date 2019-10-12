//
//  CodableParser.swift
//  Network-lib
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation


/// the Parser Responsible for parsing Data to any object of type Codable
public struct CodableParser: ParserProtocol {


    public init() { }

    /// method called for parsing data to Object o f type Codable
    ///
    /// - Parameter data: dat need to be parsed
    /// - Returns: return the expected Data as type required, and nil in case error in parsing the Data
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
