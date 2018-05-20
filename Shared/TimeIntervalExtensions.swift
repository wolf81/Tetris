//
//  TimeIntervalExtensions.swift
//  Tetris
//
//  Created by Wolfgang Schreurs on 19/05/2018.
//  Copyright © 2018 Wolftrail. All rights reserved.
//

import Foundation

extension TimeInterval {
    var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
}
