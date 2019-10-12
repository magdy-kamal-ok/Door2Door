//
//  SocketManagerMock.swift
//  NetworkManagerTests
//
//  Created by mac on 10/12/19.
//  Copyright © 2019 OwnProjects. All rights reserved.
//

import Foundation
import Foundation
import RxSwift
@testable import AllygatorShuttle

class SocketManagerMock: SocketManagerType {
    func connect() -> Observable<BookingEvent> {
        return Observable.create { observer in
            let bundle = Bundle(for: type(of: self))
            let url = bundle.url(forResource: "websocket-stub", withExtension: "json")
            var events: [BookingEvent] = []
            do {
                let data = try Data(contentsOf: url!)
                events = try JSONDecoder().decode([BookingEvent].self, from: data)
            } catch {
                observer.onError(error)
            }
            return Observable<Int>
                .timer(.seconds(0), period: .nanoseconds(1), scheduler: MainScheduler.instance)
                .takeWhile { $0 < events.count }
                .map { events[$0] }
                .subscribe(observer)
        }
    }
}
