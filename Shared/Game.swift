//
//  Game.swift
//  Tetris
//
//  Created by Wolfgang Schreurs on 18/05/2018.
//  Copyright © 2018 Wolftrail. All rights reserved.
//

import Foundation
import CoreGraphics

enum GameState {
    case none
    case running
}

class Game {
    static let shared = Game()
    
    private(set) var removedRowCount: Int = 0

    private let stepTimeMs = 300
    
    private(set) var board: Board
    private(set) var spawnedPiece: Tetromino
    private(set) var spawnedPieceLocation: CGPoint

    private var elapsedTimeMs: Int = 0
    private var keyboardElapsedTimeMs: Int = 0
    
    private(set) var state: GameState = .none
    
    var keyState: KeyState = [.none]

    private init() {
        self.board = Board()
        
        self.spawnedPiece = Tetromino(type: TetrominoType.random)
        let x = (self.board.width - self.spawnedPiece.dimension) / 2
        let y = (self.board.height - self.spawnedPiece.dimension)
        self.spawnedPieceLocation = CGPoint(x: x, y: y)
    }
    
    func start() {
        self.board.reset()
        
        self.removedRowCount = 0
        self.state = .running
        self.keyState = []
    }
    
    func finish() {
        self.state = .none
    }
    
    func update(deltaTime: TimeInterval) {
        if self.state == .none {
            return
        }
        
        self.elapsedTimeMs += deltaTime.milliseconds
        self.keyboardElapsedTimeMs += deltaTime.milliseconds
        
        if self.keyboardElapsedTimeMs > 200 {
            var newSpawnedPieceLocation = self.spawnedPieceLocation

            if self.keyState.contains(.left) || self.keyState.contains(.right) {
                newSpawnedPieceLocation.x += self.keyState.contains(.left) ? -1 : 1

                let placeState = canPlacePiece(self.spawnedPiece,
                                               onBoard: self.board,
                                               x: Int(newSpawnedPieceLocation.x),
                                               y: Int(newSpawnedPieceLocation.y))
                if placeState == .canPlace {
                    self.spawnedPieceLocation = newSpawnedPieceLocation
                }
                
                self.keyboardElapsedTimeMs = 0
            }
            
            if self.keyState.contains(.up) {
                let newSpawnedPiece = self.spawnedPiece.rotate(direction: .left)
                
                let placeState = canPlacePiece(newSpawnedPiece,
                                               onBoard: self.board,
                                               x: Int(newSpawnedPieceLocation.x),
                                               y: Int(newSpawnedPieceLocation.y))
                if placeState == .canPlace {
                    self.spawnedPiece = newSpawnedPiece
                }

                self.keyboardElapsedTimeMs = 0
            }
            
            if self.keyState.contains(.down) {
                self.elapsedTimeMs += self.stepTimeMs + 1
                self.keyboardElapsedTimeMs = 175
            }            
        }

        if self.elapsedTimeMs > self.stepTimeMs {
            var newSpawnedPieceLocation = self.spawnedPieceLocation
            newSpawnedPieceLocation.y -= 1
            
            var placeState = canPlacePiece(self.spawnedPiece,
                                           onBoard: self.board,
                                           x: Int(newSpawnedPieceLocation.x),
                                           y: Int(newSpawnedPieceLocation.y))
            if placeState != .canPlace {
                placePiece(self.spawnedPiece,
                           onBoard: self.board,
                           x: Int(self.spawnedPieceLocation.x),
                           y: Int(self.spawnedPieceLocation.y))
                spawnPiece()
                
                placeState = canPlacePiece(self.spawnedPiece,
                                           onBoard: self.board,
                                           x: Int(self.spawnedPieceLocation.x),
                                           y: Int(self.spawnedPieceLocation.y))
                if placeState == .blocked {
                    self.finish()
                }
            } else {
                self.spawnedPieceLocation = newSpawnedPieceLocation
            }

            self.elapsedTimeMs = 0
        }
    }
    
    func spawnPiece() {
        let piece = Tetromino(type: .random)
        let x = (self.board.width - piece.dimension) / 2
        let y = (self.board.height - piece.dimension)

        self.spawnedPiece = piece
        self.spawnedPieceLocation = CGPoint(x: x, y: y)
    }
    
    func canPlacePiece(_ piece: Tetromino, onBoard board: Board, x: Int, y: Int) -> PlaceState {
        let dim = piece.dimension

        for px in (0 ..< dim) {
            for py in (0 ..< dim) {
                let coordx = x + px
                let coordy = y + py

                if piece[px, py] != 0 {
                    if coordx < 0 || coordx >= board.width {
                        return .offscreen
                    }
     
                    if coordy < 0 || board[coordx, coordy] != 0 {
                        return .blocked
                    }
                }
            }
        }
        
        return .canPlace
    }
    
    func placePiece(_ piece: Tetromino, onBoard board: Board, x: Int, y: Int) {
        let dim = piece.dimension
        
        for px in (0 ..< dim) {
            for py in (0 ..< dim) {
                let coordx = x + px
                let coordy = y + py
                
                if piece[px, py] != 0 {
                    let v = piece[px, py] * piece.type.rawValue
                    board[coordx, coordy] = v
                }
            }
        }
        
        self.removedRowCount += board.removeCompleteLines()
    }
}
