//
//  WeatherModelMock.swift
//  ExampleTests
//
//  Created by 大塚 周 on 2021/09/16.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
@testable import Example

class WeatherModelMock: WeatherModel {

    let result: Result<Response, WeatherError>
    
    init(result: Result<Response, WeatherError>) {
        self.result = result
    }
    
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<Response, WeatherError>) -> Void) {
        completion(result)
    }
}
