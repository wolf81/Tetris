//
//  UIColorExtensions.swift
//  Tetris
//
//  Created by Wolfgang Schreurs on 20/05/2018.
//  Copyright © 2018 Wolftrail. All rights reserved.
//

import UIKit

extension UIColor {
    /// The alphaComponent property exists in macOS but not on iOS,
    /// This extension will allow us to use the property for both iOS and macOS
    var alphaComponent: CGFloat {
        get {
            var a: CGFloat = 0
            self.getRed(nil, green: nil, blue: nil, alpha: &a)
            return a
        }
    }
}
