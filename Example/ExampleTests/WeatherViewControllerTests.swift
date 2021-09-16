//
//  WeatherViewControllerTests.swift
//  ExampleTests
//
//  Created by 渡部 陽太 on 2020/04/01.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import Example

class WeatherViewControllerTests: XCTestCase {
    
    func test_天気予報がsunnyだったらImageViewのImageにsunnyが設定されること_TintColorがredに設定されること() throws {
        let weatherHandler = WeatherHandler.live
        let weatherModelMock = WeatherModelMock(result: .success(Response(weather: .sunny, maxTemp: 0, minTemp: 0, date: Date())))
        let weatherViewController = R.storyboard.weather.instantiateInitialViewController (creator: { coder in
            return WeatherViewController(coder: coder,weatherModel: weatherModelMock,weatherHandler: weatherHandler)
        }) as! WeatherViewController
        
        weatherViewController.loadViewIfNeeded()
        weatherModelMock.fetchWeather(at: "", date: Date()) { result in
            weatherHandler.handle(weatherViewController,result)
        }
        XCTAssertEqual(weatherViewController.weatherImageView?.tintColor, R.color.red())
        XCTAssertEqual(weatherViewController.weatherImageView?.image, R.image.sunny())
    }

    func test_天気予報がcloudyだったらImageViewのImageにcloudyが設定されること_TintColorがgrayに設定されること() throws {
        let weatherHandler = WeatherHandler.live
        let weatherModelMock = WeatherModelMock(result: .success(Response(weather: .cloudy, maxTemp: 0, minTemp: 0, date: Date())))
        let weatherViewController = R.storyboard.weather.instantiateInitialViewController (creator: { coder in
            return WeatherViewController(coder: coder,weatherModel: weatherModelMock,weatherHandler: weatherHandler)
        }) as! WeatherViewController

        weatherViewController.loadViewIfNeeded()
        weatherModelMock.fetchWeather(at: "", date: Date()) { result in
            weatherHandler.handle(weatherViewController,result)
        }
        XCTAssertEqual(weatherViewController.weatherImageView?.tintColor, R.color.gray())
        XCTAssertEqual(weatherViewController.weatherImageView?.image, R.image.cloudy())
    }

    func test_天気予報がrainyだったらImageViewのImageにrainyが設定されること_TintColorがblueに設定されること() throws {
        let weatherHandler = WeatherHandler.live
        let weatherModelMock = WeatherModelMock(result: .success(Response(weather: .rainy, maxTemp: 0, minTemp: 0, date: Date())))
        let weatherViewController = R.storyboard.weather.instantiateInitialViewController (creator: { coder in
            return WeatherViewController(coder: coder,weatherModel: weatherModelMock, weatherHandler: weatherHandler)
        }) as! WeatherViewController

        weatherViewController.loadViewIfNeeded()
        weatherModelMock.fetchWeather(at: "", date: Date()) { result in
            weatherHandler.handle(weatherViewController,result)
        }
        XCTAssertEqual(weatherViewController.weatherImageView?.tintColor, R.color.blue())
        XCTAssertEqual(weatherViewController.weatherImageView?.image, R.image.rainy())
    }

    func test_最高気温_最低気温がUILabelに設定されること() {
        let maxTemp = 40
        let minTemp = -40
        let weatherHandler = WeatherHandler.live
        let weatherModelMock = WeatherModelMock(result: .success(Response(weather: .sunny, maxTemp: maxTemp, minTemp: minTemp, date: Date())))
        let weatherViewController = R.storyboard.weather.instantiateInitialViewController (creator: { coder in
            return WeatherViewController(coder: coder,weatherModel: weatherModelMock, weatherHandler: weatherHandler)
        }) as! WeatherViewController

        weatherViewController.loadViewIfNeeded()
        weatherModelMock.fetchWeather(at: "", date: Date()) { result in
            weatherHandler.handle(weatherViewController, result)
        }
        print(weatherViewController.maxTempLabel.description)
        XCTAssertEqual(weatherViewController.maxTempLabel.text, maxTemp.description)
        XCTAssertEqual(weatherViewController.minTempLabel.text, minTemp.description)
    }
    
    
}

