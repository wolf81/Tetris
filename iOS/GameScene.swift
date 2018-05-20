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
    private var rootNode: SKSpriteNode!
    private var leftButtonNode: SKSpriteNode!
    private var rightButtonNode: SKSpriteNode!
    private var aButtonNode: SKSpriteNode!
    private var bButtonNode: SKSpriteNode!
    
    private var buttonNodes: [SKSpriteNode] {
        return [self.leftButtonNode, self.rightButtonNode, self.aButtonNode, self.bButtonNode]
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.scaleMode = .aspectFit
        BlockNode.size = CGSize(width: 48, height: 48)
        
        self.leftButtonNode = self.childNode(withName: "leftButton") as! SKSpriteNode
        self.rightButtonNode = self.childNode(withName: "rightButton") as! SKSpriteNode
        self.aButtonNode = self.childNode(withName: "aButton") as! SKSpriteNode
        self.bButtonNode = self.childNode(withName: "bButton") as! SKSpriteNode
     
        let buttonHeight: CGFloat = 100
        self.rootNode = SKSpriteNode(color: SKColor.white, size: CGSize(width: self.frame.width, height: self.frame.height - buttonHeight))
        self.rootNode.position = CGPoint(x: self.position.x, y: self.position.y + buttonHeight / 2)
        addChild(self.rootNode)
        
        self.buttonNodes.forEach { (node) in
            node.zPosition = 1000
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if self.bButtonNode.frame.contains(pos) {
            Game.shared.keyState.insert(.up)
        } else if self.aButtonNode.contains(pos) {
            Game.shared.keyState.insert(.down)
        } else if self.leftButtonNode.contains(pos) {
            Game.shared.keyState.insert(.left)
        } else if self.rightButtonNode.contains(pos) {
            Game.shared.keyState.insert(.right)
        }
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
        } else {
            if self.bButtonNode.frame.contains(pos) {
                Game.shared.keyState.remove(.up)
            } else if self.aButtonNode.contains(pos) {
                Game.shared.keyState.remove(.down)
            } else if self.leftButtonNode.contains(pos) {
                Game.shared.keyState.remove(.left)
            } else if self.rightButtonNode.contains(pos) {
                Game.shared.keyState.remove(.right)
            }
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
        
        self.rootNode.removeAllChildren()
        
        for y in (0 ..< visibleHeight) {
            for x in (0 ..< Game.shared.board.width) {
                let v = Game.shared.board[x, y]
                let color = colorForBoardValue(v)
                let node = BlockNode(color: color)
                
                let xPos = originX + CGFloat(x) * blockSize.width
                let yPos = originY + CGFloat(y) * blockSize.height
                
                node.position = CGPoint(x: xPos, y: yPos)
                self.rootNode.addChild(node)
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
                    self.rootNode.addChild(node)
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
