//
//  RswiftExtension.swift
//  Example
//
//  Created by 大塚 周 on 2021/09/24.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import Rswift

public extension StoryboardResourceWithInitialControllerType {
    
    @available(iOS 13.0, tvOS 13.0, *)
    func instantiateInitialViewController<ViewController>(creator: ((NSCoder) -> ViewController?)? = nil) -> UIViewController? where ViewController: UIViewController {
        UIStoryboard(resource: self).instantiateInitialViewController { coder in
            creator?(coder)
        }
    }
    
}
