//
//  DisasterModel.swift
//  Example
//
//  Created by 渡部 陽太 on 2020/04/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation
import YumemiWeather

protocol DisasterModel {
    func fetchDisaster(completion: ((String) -> Void)?)
}

final class DisasterModelImpl: DisasterModel {
        
    private let yumemiDisaster: YumemiDisaster
    private var fetchDisasterHandler: ((String) -> Void)?
    
    init(yumemiDisaster: YumemiDisaster = YumemiDisaster()) {
        self.yumemiDisaster = yumemiDisaster
        self.yumemiDisaster.delegate = self
    }

    func fetchDisaster(completion: ((String) -> Void)?) {
        self.fetchDisasterHandler = completion
        self.yumemiDisaster.fetchDisaster()
    }
}

extension DisasterModelImpl: YumemiDisasterHandleDelegate {
    
    func handle(disaster: String) {
        self.fetchDisasterHandler?(disaster)
    }
    
}
