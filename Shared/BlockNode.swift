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
    init(texture: SKTexture) {
        super.init(texture: texture, color: SKColor.white, size: BlockNode.size)
    }
    
    init(color: SKColor) {
        super.init(texture: nil, color: color, size: BlockNode.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    static var size: CGSize = CGSize(width: 32, height: 32)
}
