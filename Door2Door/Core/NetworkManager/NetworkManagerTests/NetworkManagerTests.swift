//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import NetworkManager

class NetworkManagerTests: XCTestCase {
    var sut: EventDataProvider<CarModel>?
    let disposeBag = DisposeBag()
    var testScheduler: TestScheduler?
    override func setUp() {
        testScheduler = TestScheduler.init(initialClock: 0)

    }

    override func tearDown() {
        sut = nil
        testScheduler?.stop()
    }

    func testEventRequestManagerSuccessful() {

        let requestFactory = RequestFactory.init(endPoint: "CarModelList")
        sut = EventDataProvider.init(requestHandler: requestFactory, socketManager: MockedSocketManager.init())
        testScheduler?.start()
        let cars = try! sut?.execute().toBlocking().toArray()
        XCTAssert(cars?.count == 10)
    }


    func testEventRequestManagerFailure()
    {
        let requestFactory = RequestFactory.init(endPoint: "ShapeList")
        sut = EventDataProvider.init(requestHandler: requestFactory, socketManager: MockedSocketManager.init())
        testScheduler?.start()
        let cars = try? sut?.execute().toBlocking().toArray()
        XCTAssertNil(cars)

    }
}
