//
//  QueueScheduler.swift
//  Example
//
//  Created by 大塚 周 on 2021/09/17.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Dispatch

struct QueueScheduler {
    var schedule:  (_ group: DispatchGroup?, @escaping () -> Void) -> Void
}

extension QueueScheduler {
    static let main = Self(
        schedule: { group, action  in
            DispatchQueue.main.async {
                action()
            }
        }
    )
}

extension QueueScheduler {
    static let immediate = Self(
        schedule: { group, action  in
            action()
        }
    )
}

extension QueueScheduler {
    static let global = Self(
        schedule: { group, action  in
            DispatchQueue.global().async(group: group) {
                action()
            }
        }
    )
}
