//
//  GameScene.swift
//  Tetris-macOS
//
//  Created by Wolfgang Schreurs on 17/05/2018.
//  Copyright © 2018 Wolftrail. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var backgroundNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundNode = self.childNode(withName: "backgroundNode") as! SKSpriteNode
        self.backgroundNode.size = self.size

        let topColor = CIColor(red: 61.0 / 255, green: 74.0 / 255, blue: 103.0 / 255, alpha: 1.0)
        let botColor = CIColor(red: 76.0 / 255, green: 108.0 / 255, blue: 181.0 / 255, alpha: 1.0)
        let bgTexture = SKTexture(gradientWithTopColor: topColor, bottomColor: botColor, size: self.size)
        self.backgroundNode.texture = bgTexture
        self.backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundNode.zPosition = -1000
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if Game.shared.state == .none {
            Game.shared.start()
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 123: Game.shared.keyState.remove(.left)
        case 124: Game.shared.keyState.remove(.right)
        case 125: Game.shared.keyState.remove(.down)
        case 126: Game.shared.keyState.remove(.up)
        default:
            print("keyUp: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 123: Game.shared.keyState.insert(.left)
        case 124: Game.shared.keyState.insert(.right)
        case 125: Game.shared.keyState.insert(.down)
        case 126: Game.shared.keyState.insert(.up)
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    private var lastTime: TimeInterval = 0.0
    
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
        
        for child in self.children {
            if child.name != "backgroundNode" {
                child.removeFromParent()
            }
        }
        
        for y in (0 ..< visibleHeight) {
            for x in (0 ..< Game.shared.board.width) {
                let v = Game.shared.board[x, y]
                var node: BlockNode
                
                if v == 0 {
                    let color = colorForBoardValue(v)
                    node = BlockNode(color: color)
                } else {
                    let type = TetrominoType(rawValue: v)
                    node = BlockNode(texture: type!.texture)
                }
                
                let xPos = originX + CGFloat(x) * blockSize.width
                let yPos = originY + CGFloat(y) * blockSize.height
                
                node.position = CGPoint(x: xPos, y: yPos)
                node.zPosition = 1
                addChild(node)
            }
        }
        
        let dim = Game.shared.spawnedPiece.dimension
        let pieceX = originX + Game.shared.spawnedPieceLocation.x * blockSize.width
        let pieceY = originY + Game.shared.spawnedPieceLocation.y * blockSize.height
        
        for y in (0 ..< dim) {
            for x in (0 ..< dim) {
                if Game.shared.spawnedPiece[x, y] != 0 {
                    var node: BlockNode
                    
                    let type = TetrominoType(rawValue: Game.shared.spawnedPiece.type.rawValue)
                    node = BlockNode(texture: type!.texture)
                    node.zPosition = 1000
                    
                    if Int(Game.shared.spawnedPieceLocation.y) + y >= visibleHeight {
                        continue
                    }
                    
                    node.position = CGPoint(x: pieceX + (CGFloat(x) * blockSize.width),
                                            y: pieceY + (CGFloat(y) * blockSize.height))
                    addChild(node)
                    node.zPosition = 1
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
