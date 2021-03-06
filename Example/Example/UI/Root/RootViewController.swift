//
//  RootViewController.swift
//  Example
//
//  Created by 渡部 陽太 on 2020/04/01.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let weatherModel = WeatherModelImpl()
        let disasterModel = DisasterModelImpl()
        
        guard let viewController = R.storyboard.weather.instantiateInitialViewController (creator: { coder in
            return WeatherViewController(coder: coder,weatherModel: weatherModel, disasterModel: disasterModel)
        }) else {
            assertionFailure("WeatherViewControllerのイニシャライザに失敗した")
            return
        }
        
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }

}

