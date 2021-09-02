//
//  ViewController.swift
//  Example
//
//  Created by 渡部 陽太 on 2020/03/30.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol WeatherModel {
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<Response, WeatherError>) -> Void)
}

protocol DisasterModel {
    func fetchDisaster(completion: ((String) -> Void)?)
}

class WeatherViewController: UIViewController {
    
    let weatherModel: WeatherModel
    let disasterModel: DisasterModel
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var disasterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    init?(coder: NSCoder, weatherModel: WeatherModel, disasterModel: DisasterModel) {
        self.weatherModel = weatherModel
        self.disasterModel = disasterModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function)
    }
            
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reload(_ sender: Any?) {
        loadWeather()
    }
    
    private func loadWeather() {
        showIndicator {
            self.weatherModel.fetchWeather(at: "tokyo", date: Date()) { result in
                DispatchQueue.main.async {
                    self.handleWeather(result: result)
                }
            }
            self.disasterModel.fetchDisaster { disaster in
                DispatchQueue.main.async {
                    self.disasterLabel.text = disaster
                }
            }
        }
    }
    
    private func showIndicator(while processings: () -> Void...) {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue.global()
        
        switchView()
        
        processings.forEach { processing in
            dispatchQueue.async(group: dispatchGroup) {
                processing()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.switchView()
        }
    }
    
    private func switchView() {
        activityIndicator.toggleAnimation()
        reloadButton.toggleEnabled()
        closeButton.toggleEnabled()
    }
    
    func handleWeather(result: Result<Response, WeatherError>) {
        switch result {
        case .success(let response):
            self.weatherImageView.set(weather: response.weather)
            self.minTempLabel.text = String(response.minTemp)
            self.maxTempLabel.text = String(response.maxTemp)
            
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
                message = "エラーが発生しました。"
            }
            
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true) {
                    print("Close ViewController by \(alertController)")
                }
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
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

private extension UIButton {
    func toggleEnabled() {
        self.isEnabled = !self.isEnabled
    }
}

private extension UIActivityIndicatorView {
    func toggleAnimation() {
        if self.isAnimating {
            self.stopAnimating()
        } else {
            self.startAnimating()
        }
    }
}
