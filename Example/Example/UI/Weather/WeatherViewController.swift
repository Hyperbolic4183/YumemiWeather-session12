//
//  ViewController.swift
//  Example
//
//  Created by 渡部 陽太 on 2020/03/30.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private let weatherModel: WeatherModel
    private let disasterModel: DisasterModel
    private let weatherHandler: WeatherHandler
    
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
    
    init?(coder: NSCoder, weatherModel: WeatherModel, disasterModel: DisasterModel = DisasterModelImpl(), weatherHandler: WeatherHandler = .live) {
        self.weatherModel = weatherModel
        self.disasterModel = disasterModel
        self.weatherHandler = weatherHandler
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
            
            self.weatherModel.fetchWeather(at: "tokyo", date: Date()) { [weak self] result in
                self?.handleWeather(result: result)
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
    
    private func handleWeather(result: Result<Response, WeatherError>) {
        weatherHandler.handle(self,result)
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
