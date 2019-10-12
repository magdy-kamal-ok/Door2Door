//
//  NetworkManagerParserTests.swift
//  NetworkManagerTests
//
//  Created by mac on 10/12/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import XCTest
@testable import NetworkManager
class NetworkManagerParserTests: XCTestCase {

    var sut: ParserProtocol!

    override func setUp() {
        sut = CodableParser.init()
    }

    override func tearDown() {
        sut = nil
    }

    func testParsingDataSuccessful() {

        let bundle = Bundle(for: NetworkManagerTests.self)
        let dataPath = bundle.url(forResource: "CarModel", withExtension: "json")
        let data = try! Data(contentsOf: dataPath!)
        var parsedCarModel: CarModel?
        if let carModel: CarModel = sut.parseData(data: data)
        {
            parsedCarModel = carModel
        }
        XCTAssertNotNil(parsedCarModel)
        XCTAssert(parsedCarModel?.carNumber == 1)

    }
    func testParsingDataFailure() {
        sut = CodableParser.init()
        let bundle = Bundle(for: NetworkManagerTests.self)
        let dataPath = bundle.url(forResource: "ShapeModel", withExtension: "json")
        let data = try! Data(contentsOf: dataPath!)
        var parsedCarModel: CarModel?
        if let carModel: CarModel = sut.parseData(data: data)
        {
            parsedCarModel = carModel
        }
        XCTAssertNil(parsedCarModel)

    }

}
