//
//  QueueScheduler.swift
//  Example
//
//  Created by 大塚 周 on 2021/09/17.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Dispatch

struct QueueScheduler {
    private let schedule: (DispatchGroup?, @escaping () -> Void) -> Void
    init(schedule: @escaping (DispatchGroup?, @escaping () -> Void) -> Void ) {
        self.schedule = schedule
    }
    
    func schedule(group: DispatchGroup? = nil, action: @escaping () -> Void) {
        schedule(group, action)
    }
    
}

extension QueueScheduler {
    static let main = Self(
        schedule: { group, action in
            DispatchQueue.main.async(group: group) {
                action()
            }
        }
    )
}

extension QueueScheduler {
    static let immediate = Self(
        schedule: { _, action in
            action()
        }
    )
}

extension QueueScheduler {
    static let global = Self(
        schedule: { group, action in
            DispatchQueue.global().async(group: group) {
                action()
            }
        }
    )
}
