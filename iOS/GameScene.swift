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
        if Game.shared.state == .none {
            Game.shared.start()
        }
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
        let deltaTime = currentTime - self.lastTime
        self.lastTime = currentTime
        
        while accumulatedFrames > 0 {
            Game.shared.update(deltaTime: deltaTime)
            accumulatedFrames -= 1
        }
        
        render()
    }
    
    private func render() {
        let blockSize = BlockNode.size
        
        let visibleHeight = Game.shared.board.height - 2
        
        let originX = (self.size.width - (CGFloat(Game.shared.board.width) * blockSize.width)) / 2 + (blockSize.width / 2)
        let originY = (self.size.height - (CGFloat(visibleHeight) * blockSize.height)) / 2 + (blockSize.height / 2)
        
        self.removeAllChildren()
        
        for y in (0 ..< visibleHeight) {
            for x in (0 ..< Game.shared.board.width) {
                let v = Game.shared.board[x, y]
                let color = colorForBoardValue(v)
                let node = BlockNode(color: color)
                
                let xPos = originX + CGFloat(x) * blockSize.width
                let yPos = originY + CGFloat(y) * blockSize.height
                
                node.position = CGPoint(x: xPos, y: yPos)
                addChild(node)
            }
        }
        
        let dim = Game.shared.spawnedPiece.dimension
        let pieceX = originX + Game.shared.spawnedPieceLocation.x * blockSize.width
        let pieceY = originY + Game.shared.spawnedPieceLocation.y * blockSize.height
        
        for y in (0 ..< dim) {
            for x in (0 ..< dim) {
                if Game.shared.spawnedPiece[x, y] != 0 {
                    let color = colorForBoardValue(Game.shared.spawnedPiece.type.rawValue)
                    let node = BlockNode(color: color)
                    
                    if Int(Game.shared.spawnedPieceLocation.y) + y >= visibleHeight {
                        continue
                    }
                    
                    node.position = CGPoint(x: pieceX + (CGFloat(x) * blockSize.width),
                                            y: pieceY + (CGFloat(y) * blockSize.height))
                    addChild(node)
                }
            }
        }
    }
    
    private func colorForBoardValue(_ value: Int) -> SKColor {
        switch value {
        case TetrominoType.I.rawValue: return SKColor.orange
        case TetrominoType.J.rawValue: return SKColor.red
        case TetrominoType.L.rawValue: return SKColor.purple
        case TetrominoType.O.rawValue: return SKColor.blue
        case TetrominoType.S.rawValue: return SKColor.yellow
        case TetrominoType.T.rawValue: return SKColor.green
        case TetrominoType.Z.rawValue: return SKColor.cyan
        default: return SKColor.white.withAlphaComponent(0.5)
        }
    }
}
