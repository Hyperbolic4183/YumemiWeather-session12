//
//  weatherHandler.swift
//  Example
//
//  Created by 大塚 周 on 2021/09/16.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

struct WeatherHandler {
    var handle: (_ viewController: WeatherViewController, _ result: Result<Response, WeatherError>) -> Void
}

extension WeatherHandler {
    static let live = Self(
        handle: { viewController, result in
            switch result {
            case .success(let response):
                viewController.weatherImageView.set(weather: response.weather)
                viewController.minTempLabel.text = String(response.minTemp)
                viewController.maxTempLabel.text = String(response.maxTemp)

            case .failure(let error):
                let message: String
                switch error {
                case .jsonEncodeError:
                    message = "Jsonエンコードに失敗しました。"
                case .jsonDecodeError:
                    message = "Jsonデコードに失敗しました。"
                case .invalidParameterError:
                    message = "不適切な値が設定されました"
                case .unknownError:
                    message = "天気予報の取得に失敗しました"
                }

                let alertController = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                viewController.weatherImageView.setErrorOccurred()
                viewController.maxTempLabel.text = "--"
                viewController.minTempLabel.text = "--"
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    )
}

private extension UIImageView {
    func set(weather: Weather) {
        switch weather {
        case .sunny:
            self.image = R.image.sunny()
            self.tintColor = R.color.red()
        case .cloudy:
            self.image = R.image.cloudy()
            self.tintColor = R.color.gray()
        case .rainy:
            self.image = R.image.rainy()
            self.tintColor = R.color.blue()
        }
    }
    
    func setErrorOccurred() {
        self.image = UIImage(systemName: "xmark.octagon", withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))
        self.tintColor = .black
    }
}
