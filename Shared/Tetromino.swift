//
//  Piece.swift
//  Tetris
//
//  Created by Wolfgang Schreurs on 17/05/2018.
//  Copyright © 2018 Wolftrail. All rights reserved.
//

import Foundation
import SpriteKit

enum RotateDirection {
    case left
    case right
}

enum TetrominoType: Int {
    case O = 1
    case I
    case J
    case Z
    case S
    case T
    case L
    
    static var random: TetrominoType {
        let types: [TetrominoType] = [.O, .I, .J, .Z, .S, .T, .L]
        let idx = arc4random_uniform(UInt32(types.count))
        return types[Int(idx)]
    }
}

class Tetromino {
    private var tetromino: [[Int]]

    fileprivate(set) var type: TetrominoType
    
    /// Every piece is wrapped in a 2-dimensional array with equal width and hight.
    var dimension: Int {
        return self.tetromino.count
    }
    
    init(type: TetrominoType) {
        self.type = type
        
        switch type {
        case .L: self.tetromino = [
            [1, 0, 0],
            [1, 1, 1],
            [0, 0, 0],
        ]
        case .I: self.tetromino = [
            [0, 0, 0, 0],
            [1, 1, 1, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
        ]
        case .J: self.tetromino = [
            [0, 0, 1],
            [1, 1, 1],
            [0, 0, 0],
        ]
        case .O: self.tetromino = [
            [1, 1],
            [1, 1],
        ]
        case .S: self.tetromino = [
            [0, 1, 1],
            [1, 1, 0],
            [0, 0, 0],
        ]
        case .T: self.tetromino = [
            [0, 1, 0],
            [1, 1, 1],
            [0, 0, 0],
        ]
        case .Z: self.tetromino = [
            [1, 1, 0],
            [0, 1, 1],
            [0, 0, 0],
        ]
        }
        
        print(self.description)
    }

    subscript(x: Int, y: Int) -> Int {
        get {
            return self.tetromino[self.dimension - y - 1][x]
        }
        set(newValue) {
            self.tetromino[self.dimension - y - 1][x] = newValue
        }
    }

    func rotate(direction: RotateDirection) -> Tetromino {
        let dim = self.dimension
        
        var rotated = self.tetromino
        for i in (0 ..< dim) {
            for j in (0 ..< dim) {
                switch direction {
                case .left:
                    rotated[j][i] = self.tetromino[i][dim - 1 - j]
                case .right:
                    rotated[j][i] = self.tetromino[dim - 1 - i][j]
                }
            }
        }
        
        let piece = Tetromino(type: self.type)
        piece.tetromino = rotated
        return piece
    }
}

// MARK: - CustomStringConvertible

extension Tetromino: CustomStringConvertible {
    var description: String {
        var desc = "\n"
        
        let dim = self.dimension
        for y in (0 ..< dim).reversed() {
            for x in (0 ..< dim) {
                desc += " \(self[x, y])"
            }
            
            desc += "\n"
        }
        
        return desc
    }
}
