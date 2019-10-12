//
//  RequestFactoryTests.swift
//  NetworkManagerTests
//
//  Created by mac on 10/12/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import XCTest
@testable import NetworkManager

class RequestFactoryTests: XCTestCase {
    var sut: RequstHandlerProtocol?
    let endPint = "wss://echo.websocket.org"
    override func setUp() {
        sut = RequestFactory.init(endPoint: endPint)
    }

    override func tearDown() {
        sut = nil
    }


    func testRequestFactoryEndPointSuccess()
    {
        XCTAssert(sut?.getSocketEndPoint() == endPint)
    }
    func testRequestFactoryEndPointFailure()
    {
        sut = nil
        XCTAssertNotEqual(sut?.getSocketEndPoint(), endPint)
    }



}
