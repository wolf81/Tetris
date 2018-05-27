//
//  Board.swift
//  Tetris
//
//  Created by Wolfgang Schreurs on 19/05/2018.
//  Copyright © 2018 Wolftrail. All rights reserved.
//

import Foundation

class Board {
    private static var width = 10
    private static var height = 22
    
    private var board: [[Int]]
    
    var width: Int {
        return self.board[0].count
    }
    
    var height: Int {
        return self.board.count
    }
    
    init() {
        self.board = Array(repeating: Array(repeating: 0, count: Board.width),
                           count: Board.height)
    }
    
    subscript(x: Int, y: Int) -> Int {
        get {
            return self.board[self.height - y - 1][x]
        }
        set(newValue) {
            self.board[self.height - y - 1][x] = newValue
        }
    }
    
    func reset() {
        self.board = Array(repeating: Array(repeating: 0, count: Board.width),
                           count: Board.height)
    }
    
    func removeCompleteLines() -> Int {
        var lineCount = 0
        
        for var y in (0 ..< self.height).reversed() {
            var isComplete = true
            
            for x in (0 ..< self.width) {
                if self[x, y] == 0 {
                    isComplete = false
                }
            }
            
            if isComplete {
                lineCount += 1
                
                for yc in (y ..< (self.height - 1)) {
                    for x in (0 ..< self.width) {
                        self[x, yc] = self[x, yc + 1]
                    }
                }
                
                y += 1
            }
        }
        
        return lineCount
    }
}

// MARK: - CustomStringConvertible

extension Board: CustomStringConvertible {
    var description: String {
        var desc = "\n"
        
        self.board.forEach { (row) in
            row.forEach({ (col) in
                desc += " \(col)"
            })
            
            desc += "\n"
        }
        
        return desc
    }
}
