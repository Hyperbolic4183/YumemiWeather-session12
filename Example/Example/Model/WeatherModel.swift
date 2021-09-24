//
//  WeatherModel.swift
//  Example
//
//  Created by 渡部 陽太 on 2020/04/01.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation
import YumemiWeather

protocol WeatherModel {
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<Response, WeatherError>) -> Void)
}

final class WeatherModelImpl: WeatherModel {
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    func jsonString(from request: Request) throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        let requestData = try encoder.encode(request)
        guard let requestJsonString = String(data: requestData, encoding: .utf8) else {
            throw WeatherError.jsonEncodeError
        }
        return requestJsonString
    }
    
    func fetch(from jsonString: String) throws -> String {
        do {
            return try YumemiWeather.syncFetchWeather(jsonString)
        } catch let error as YumemiWeatherError {
            switch error {
            case .invalidParameterError:
                throw WeatherError.invalidParameterError
            case .unknownError:
                throw WeatherError.unknownError
            }
        }
    }
    
    func response(from jsonString: String) throws -> Response {
        guard let responseData = jsonString.data(using: .utf8) else {
            throw WeatherError.jsonDecodeError
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Response.self, from: responseData)
    }
    
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<Response, WeatherError>) -> Void) {
        let request = Request(area: area, date: date)
        do {
            let requestJson = try jsonString(from: request)
            let responseJson = try fetch(from: requestJson)
            let response = try self.response(from: responseJson)
            completion(.success(response))
        } catch let error as WeatherError {
            switch error {
            case .jsonEncodeError:
                completion(.failure(error))
            case .jsonDecodeError:
                completion(.failure(error))
            case .invalidParameterError:
                completion(.failure(error))
            case .unknownError:
                completion(.failure(error))
            }
        } catch {
            completion(.failure(.unknownError))
        }
    }
}
