//
//  BlockNode.swift
//  Tetris
//
//  Created by Wolfgang Schreurs on 19/05/2018.
//  Copyright © 2018 Wolftrail. All rights reserved.
//

import Foundation
import SpriteKit

class BlockNode : SKSpriteNode {
    init(color: SKColor) {
        let texture = SKTexture(imageNamed: "block")
        super.init(texture: texture, color: color, size: BlockNode.size)        
        self.colorBlendFactor = 1.0
        
        #if os(iOS)
        var a: CGFloat = 0
        color.getRed(nil, green: nil, blue: nil, alpha: &a)
        self.alpha = a
        #elseif os(macOS)
        self.alpha = color.alphaComponent
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    static var size: CGSize {
        return CGSize(width: 32, height: 32)
    }
}
