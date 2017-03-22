//
//  NSDate_extension.swift
//  Thinh
//
//  Created by Tran Quang Dat on 3/20/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit

extension Date {
    static func currentTimeInMillis() -> TimeInterval {
        return Date().timeIntervalSince1970 * 1000
    }
}
