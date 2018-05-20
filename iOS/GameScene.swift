//
//  GameScene.swift
//  Tetris
//
//  Created by Wolfgang Schreurs on 17/05/2018.
//  Copyright © 2018 Wolftrail. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    var lastTime: TimeInterval = 0.0
    
    override func update(_ currentTime: TimeInterval) {
        if (self.lastTime == 0.0) {
            self.lastTime = currentTime
        }
        
        var accumulatedFrames = round((currentTime - self.lastTime) * 60)
        self.lastTime = currentTime
        
        while accumulatedFrames > 0 {
            Game.shared.update()
            accumulatedFrames -= 1
        }
        
        let originX = self.size.width - Game.shared.board.width
        let originY = self.size.height - Game.shared.board.height
        
        self.removeAllChildren()
        
        for y in (0 ..< Game.shared.board.height) {
            for x in (0 ..< Game.shared.board.height) {
                let node = BlockNode(color: SKColor.lightGray)
                
                let xPos = originX
                let yPos = originY
            }
        }
    }
    
    func blockWithColor(_ color: SKColor, size: CGSize) -> SKSpriteNode {
        return SKSpriteNode(color: color, size: size)
    }
}
