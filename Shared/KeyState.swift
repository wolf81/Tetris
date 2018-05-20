//
//  KeyboardState.swift
//  Tetris
//
//  Created by Wolfgang Schreurs on 19/05/2018.
//  Copyright © 2018 Wolftrail. All rights reserved.
//

import Foundation

struct KeyState: OptionSet {
    let rawValue: Int
    
    static let none = KeyState(rawValue: 0)
    static let left = KeyState(rawValue: 1 << 0)
    static let right = KeyState(rawValue: 1 << 1)
    static let up = KeyState(rawValue: 1 << 2)
    static let down = KeyState(rawValue: 1 << 3)
}
