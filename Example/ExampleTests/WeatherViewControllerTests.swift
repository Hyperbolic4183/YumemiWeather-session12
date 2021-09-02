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

    var weatherViewController: WeatherViewController!
    var stackView: UIView!
    var imageView: UIImageView!
    var maxTempLabel: UILabel!
    var minTempLabel: UILabel!

    func test_天気予報がsunnyだったらImageViewのImageにsunnyが設定されること_TintColorがredに設定されること() throws {
       
        weatherViewController  = R.storyboard.weather.instantiateInitialViewController { coder in
            return WeatherViewController(coder: coder, weatherModel: WeatherModelMock(weather: .sunny), disasterModel: DisasterModelImpl())
        } as? WeatherViewController
        
        stackView = getStackView(from: weatherViewController)
        imageView = getImageView(from: stackView!)
        
        weatherViewController.handleWeather(result: .success(Response(weather: .sunny, maxTemp: 0, minTemp: 0, date: Date())))
        
        XCTAssertEqual(imageView?.tintColor, R.color.red())
        XCTAssertEqual(imageView?.image, R.image.sunny())
    }

    func test_天気予報がcloudyだったらImageViewのImageにcloudyが設定されること_TintColorがgrayに設定されること() throws {
        let cloudyWeatherViewController = R.storyboard.weather.instantiateInitialViewController { coder in
            return WeatherViewController(coder: coder, weatherModel: WeatherModelMock(weather: .cloudy), disasterModel: DisasterModelImpl())
        } as! WeatherViewController

        stackView = getStackView(from: cloudyWeatherViewController)
        imageView = getImageView(from: stackView!)
        cloudyWeatherViewController.handleWeather(result: .success(Response(weather: .cloudy, maxTemp: 0, minTemp: 0, date: Date())))

        XCTAssertEqual(imageView?.tintColor, R.color.gray())
        XCTAssertEqual(imageView?.image, R.image.cloudy())
    }

    func test_天気予報がrainyだったらImageViewのImageにrainyが設定されること_TintColorがblueに設定されること() throws {
        let rainyWeatherViewController = R.storyboard.weather.instantiateInitialViewController { coder in
            return WeatherViewController(coder: coder, weatherModel: WeatherModelMock(weather: .rainy), disasterModel: DisasterModelImpl())
        } as! WeatherViewController

        stackView = getStackView(from: rainyWeatherViewController)
        imageView = getImageView(from: stackView!)
        rainyWeatherViewController.handleWeather(result: .success(Response(weather: .rainy, maxTemp: 0, minTemp: 0, date: Date())))

        XCTAssertEqual(imageView?.tintColor, R.color.blue())
        XCTAssertEqual(imageView?.image, R.image.rainy())
    }

    func test_最高気温_最低気温がUILabelに設定されること() throws {
        let maxTemp = 40
        let minTemp = -40
        let tempWeatherViewController = R.storyboard.weather.instantiateInitialViewController { coder in
            return WeatherViewController(coder: coder, weatherModel: WeatherModelMock(maxTemp: maxTemp, minTemp: minTemp), disasterModel: DisasterModelImpl())
        } as! WeatherViewController
        stackView = getStackView(from: tempWeatherViewController)
        maxTempLabel = getMaxLabel(from: stackView!)
        minTempLabel = getMinLabel(from: stackView!)

        tempWeatherViewController.handleWeather(result: .success(Response(weather: .sunny, maxTemp: maxTemp, minTemp: minTemp, date: Date())))

        XCTAssertEqual(maxTempLabel?.text, maxTemp.description)
        XCTAssertEqual(minTempLabel?.text, minTemp.description)
    private func getReloadButton(from view: UIView) -> UIButton {
        let id = R.id.weather.reloadButton
        return view.subviews.lazy.filter({ $0.accessibilityIdentifier == id }).compactMap({ $0 as? UIButton }).first!
    }
    
    private func getStackView(from view: UIView) -> UIView {
        let id = R.id.weather.stackViewForImageViewAndLabels
        
        return view.subviews.lazy.filter({$0.accessibilityIdentifier == id}).first!
    }
    
    private func getImageView(from view: UIView) -> UIImageView {
        let id = R.id.weather.weatherImageView
        return view.subviews.lazy.filter({ $0.accessibilityIdentifier == id }).compactMap({ $0 as? UIImageView }).first!
    }
    
    private func getMaxLabel(from view: UIView) -> UILabel {
        let id = R.id.weather.maxTempLabel
        return view.subviews.lazy.filter({ $0.accessibilityIdentifier == id }).compactMap({ $0 as? UILabel }).first!
    }
    
    private func getMinLabel(from view: UIView) -> UILabel {
        let id = R.id.weather.minTempLabel
        return view.subviews.lazy.filter({ $0.accessibilityIdentifier == id }).compactMap({ $0 as? UILabel }).first!
    }
    
}

class WeatherModelMock: WeatherModel {
    
    let weather: Weather
    let maxTemp: Int
    let minTemp: Int
    let response: Response
    
    init(weather: Weather) {
        self.weather = weather
        self.maxTemp = 40
        self.minTemp = -40
        self.response = Response(weather: weather, maxTemp: maxTemp, minTemp: minTemp, date: Date())
    }
    
    init(maxTemp: Int, minTemp: Int) {
        self.weather = .sunny
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.response = Response(weather: weather, maxTemp: maxTemp, minTemp: minTemp, date: Date())
    }

    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<Response, WeatherError>) -> Void) {
        completion(.success(response))
    }
}
