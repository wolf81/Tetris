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
    private var playAreaNode: SKSpriteNode!
    
    private var rootNode: SKSpriteNode!
    
    private var backgroundNode: SKSpriteNode!
    private var leftButtonNode: SKSpriteNode!
    private var rightButtonNode: SKSpriteNode!
    private var downButtonNode: SKSpriteNode!
    private var rotateButtonNode: SKSpriteNode!
    
    private let buttonHeight: CGFloat = 110
    private let infoHeight: CGFloat = 60
    
    private var infoBlockSize: CGSize = CGSize(width: 10, height: 10)
    
    private var buttonNodes: [SKSpriteNode] {
        return [self.leftButtonNode, self.rightButtonNode, self.downButtonNode, self.rotateButtonNode]
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let padding: CGFloat = 50
        let playAreaHeight = self.scene!.frame.height - self.infoHeight - padding - self.buttonHeight - padding
        let blockHeight = playAreaHeight / 20
        let blockWidth = blockHeight
        
        self.scaleMode = .aspectFit
        BlockNode.size = CGSize(width: blockWidth, height: blockHeight)
        
        self.leftButtonNode = self.childNode(withName: "leftButton") as! SKSpriteNode
        self.rightButtonNode = self.childNode(withName: "rightButton") as! SKSpriteNode
        self.downButtonNode = self.childNode(withName: "downButton") as! SKSpriteNode
        self.rotateButtonNode = self.childNode(withName: "rotateButton") as! SKSpriteNode
        self.backgroundNode = self.childNode(withName: "background") as! SKSpriteNode
        
        self.backgroundNode.size = self.scene!.frame.size
        self.backgroundNode.anchorPoint = CGPoint.zero
        let topColor = CIColor(red: 61.0 / 255, green: 74.0 / 255, blue: 103.0 / 255, alpha: 1.0)
        let botColor = CIColor(red: 76.0 / 255, green: 108.0 / 255, blue: 181.0 / 255, alpha: 1.0)
        let bgTexture = SKTexture(gradientWithTopColor: topColor, bottomColor: botColor, size: self.backgroundNode.size)
        self.backgroundNode.texture = bgTexture
        
        let horizontalPadding: CGFloat = 20
        let bgWidth = BlockNode.size.width * 10 + 20
        let bgHeight = BlockNode.size.height * 20 + 20
        let bgSize = CGSize(width: bgWidth, height: bgHeight)
        self.playAreaNode = SKSpriteNode(texture: nil, color: UIColor.black.withAlphaComponent(0.5), size: bgSize)
        self.playAreaNode.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.playAreaNode.position = CGPoint(x: self.frame.width / 2, y: buttonHeight + 20)
        self.playAreaNode.alpha = 0.5
        self.playAreaNode.zPosition = 1
        addChild(self.playAreaNode)

        self.rootNode = SKSpriteNode(texture: nil, size: bgSize)
        self.rootNode.anchorPoint = CGPoint.zero
        self.rootNode.alpha = 1.0
        self.rootNode.position = CGPoint(x: horizontalPadding, y: buttonHeight + 20)
        self.rootNode.zPosition = 2
        addChild(self.rootNode)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if self.rotateButtonNode.frame.contains(pos) {
            Game.shared.keyState.insert(.up)
        } else if self.downButtonNode.contains(pos) {
            Game.shared.keyState.insert(.down)
        } else if self.leftButtonNode.contains(pos) {
            Game.shared.keyState.insert(.left)
        } else if self.rightButtonNode.contains(pos) {
            Game.shared.keyState.insert(.right)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if Game.shared.state == .none {
            Game.shared.start()
        } else {
            if self.rotateButtonNode.frame.contains(pos) {
                Game.shared.keyState.remove(.up)
            } else if self.downButtonNode.contains(pos) {
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    var lastTime: TimeInterval = 0.0
    var deltaTime: TimeInterval = 0.0
    
    override func update(_ currentTime: TimeInterval) {
        if (self.lastTime == 0.0) {
            self.lastTime = currentTime
        }
        
        var accumulatedFrames = round((currentTime - self.lastTime) * 30)
        self.deltaTime += (currentTime - self.lastTime)
        self.lastTime = currentTime
        
        while accumulatedFrames > 0 {
            Game.shared.update(deltaTime: self.deltaTime)
            accumulatedFrames -= 1
            self.deltaTime = 0
        }
        
        render()
    }

    private func render() {
        let blockSize = BlockNode.size
        
        let visibleHeight = Game.shared.board.height - 2
        
        let originX = (self.size.width - (CGFloat(Game.shared.board.width) * blockSize.width)) / 2  //- (blockSize.width / 2)
        let originY: CGFloat = 30
        
        self.rootNode.removeAllChildren()
        
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
                node.zPosition = 500
                self.rootNode.addChild(node)
            }
        }
        
        let dim = Game.shared.spawnedPiece.dimension
        let pieceX = originX + Game.shared.spawnedPieceLocation.x * blockSize.width
        let pieceY = originY + Game.shared.spawnedPieceLocation.y * blockSize.height
        
        for y in (0 ..< dim) {
            for x in (0 ..< dim) {
                if Game.shared.spawnedPiece[x, y] != 0 {
                    let type = TetrominoType(rawValue: Game.shared.spawnedPiece.type.rawValue)
                    let node = BlockNode(texture: type!.texture)
                    
                    if Int(Game.shared.spawnedPieceLocation.y) + y >= visibleHeight {
                        continue
                    }
                    
                    node.position = CGPoint(x: pieceX + (CGFloat(x) * blockSize.width),
                                            y: pieceY + (CGFloat(y) * blockSize.height))
                    node.zPosition = 1000
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
        default: return SKColor.clear
        }
    }
}
