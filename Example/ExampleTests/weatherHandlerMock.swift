//
//  weatherHandlerMock.swift
//  ExampleTests
//
//  Created by 大塚 周 on 2021/09/17.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import Example

extension WeatherHandler {
    static let fulfillExpectation = Self(
        handle: { _,_ in
            let expectation = Expectation.weatherHandler
            expectation.fulfill()
        })
}
