//
//  SKTextureExtensions.swift
//  Tetris
//
//  Created by Wolfgang Schreurs on 22/05/2018.
//  Copyright © 2018 Wolftrail. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif
import SpriteKit

extension SKTexture {
    convenience init?(gradientWithTopColor topColor: CIColor, bottomColor: CIColor, size: CGSize) {
        let context = CIContext(options: nil)
        
        guard let gradientFilter = CIFilter(name: "CILinearGradient") else {
            return nil
        }
        
        gradientFilter.setDefaults()
        let startVector = CIVector(x: size.width / 2, y: 0)
        let endVector = CIVector(x: size.width / 2, y: size.height)
        gradientFilter.setValue(startVector, forKey: "inputPoint0")
        gradientFilter.setValue(endVector, forKey: "inputPoint1")
        gradientFilter.setValue(topColor, forKey: "inputColor0")
        gradientFilter.setValue(bottomColor, forKey: "inputColor1")
        
        guard
            let outputImage = gradientFilter.outputImage,
            let imageRef = context.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: size.width, height: size.height)) else {
            return nil
        }
        
        #if os(iOS)
        self.init(image: UIImage(cgImage: imageRef))
        #else
        self.init(image: NSImage(cgImage: imageRef, size: size))
        #endif
    }    
}
