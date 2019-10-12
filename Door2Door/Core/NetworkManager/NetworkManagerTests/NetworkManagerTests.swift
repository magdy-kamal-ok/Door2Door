//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import XCTest
import RxSwift
@testable import NetworkManager

class NetworkManagerTests: XCTestCase {
    var sut: EventDataProvider<CarModel>?
    let disposeBag = DisposeBag()
    override func setUp() {

    }

    override func tearDown() {
        sut = nil
    }

    func testEventRequestManagerSuccessful()
    {
        let requestFactory = RequestFactory.init(endPoint: "CarModelList")
        sut = EventDataProvider.init(requestHandler: requestFactory, socketManager: MockSocketManager.init())
        let expextation = expectation(description: "Success Event Manager")
        var carModel: CarModel?
        var currentError: Error?
        sut?.execute()
            .subscribe(onNext: {(car) in
                    carModel = car
                }, onError: { (error) in
                    currentError = error
                    expextation.fulfill()
            }, onCompleted: {
                expextation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expextation], timeout: 30)
        XCTAssertNil(currentError)
        XCTAssertNotNil(carModel)
    }
    
    func testEventRequestManagerFailure()
    {
        let requestFactory = RequestFactory.init(endPoint: "ShapeList")
        sut = EventDataProvider.init(requestHandler: requestFactory, socketManager: MockSocketManager.init())
        let expextation = expectation(description: "Success Event Manager")
        var carModel: CarModel?
        var currentError: Error?
        sut?.execute()
            .subscribe(onNext: {(car) in
                carModel = car
            }, onError: { (error) in
                currentError = error
                expextation.fulfill()
            }, onCompleted: {
                expextation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expextation], timeout: 30)
        XCTAssertNotNil(currentError)
        XCTAssertNil(carModel)
        
    }
}
