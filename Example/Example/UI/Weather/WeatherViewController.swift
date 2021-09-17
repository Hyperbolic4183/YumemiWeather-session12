//
//  ViewController.swift
//  Example
//
//  Created by 渡部 陽太 on 2020/03/30.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    private let weatherModel: WeatherModel
    private let disasterModel: DisasterModel
    private let weatherHandler: WeatherHandler
    private let mainQueueScheduler: QueueScheduler
    private let globalQueueScheduler: QueueScheduler
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak private var disasterLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var reloadButton: UIButton!
    @IBOutlet weak private var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    init?(coder: NSCoder, weatherModel: WeatherModel, disasterModel: DisasterModel = DisasterModelImpl(), weatherHandler: WeatherHandler = .live, mainQueueScheduler: QueueScheduler = .main, globalQueueScheduler: QueueScheduler = .global) {
        self.weatherModel = weatherModel
        self.disasterModel = disasterModel
        self.weatherHandler = weatherHandler
        self.mainQueueScheduler = mainQueueScheduler
        self.globalQueueScheduler = globalQueueScheduler
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function)
    }
            
    @IBAction private func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reload(_ sender: Any?) {
        loadWeather()
    }
    
    private func loadWeather() {
        showIndicator { [weak self] in
            self?.weatherModel.fetchWeather(at: "tokyo", date: Date()) { [weak self] result in
                self?.mainQueueScheduler.schedule() {
                    self?.handleWeather(result: result)
                }
            }
            
            self?.disasterModel.fetchDisaster { disaster in
                self?.mainQueueScheduler.schedule() {
                    self?.disasterLabel.text = disaster
                }
            }
            
        }
    }
    
    private func showIndicator(while processings: () -> Void...) {
        let dispatchGroup = DispatchGroup()
        
        switchView()
        
        processings.forEach { processing in
            globalQueueScheduler.schedule(group: dispatchGroup) {
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
        weatherHandler.handle(from: self, result)
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
