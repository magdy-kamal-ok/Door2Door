//
//  Network_libTests.swift
//  Network-libTests
//
//  Created by mac on 10/5/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import XCTest
@testable import Network_lib

class Network_libTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testExample() {
        let parser = CodableParser.init()
        let data = Data.init()
        parser.parseData(data: data, type: Test.self)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
struct Test:Codable {
    let name:String
    let car:String
}
