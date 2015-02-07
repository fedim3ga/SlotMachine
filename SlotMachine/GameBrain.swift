//
//  GameBrain.swift
//  SlotMachine
//
//  Created by Ben Blanchard on 07/02/2015.
//  Copyright (c) 2015 Ben Blanchard. All rights reserved.
//

import Foundation

class GameBrain {
    
    class func unpackCardsIntoRows(board:[[Card]]) -> [[Card]] {
        
        var firstRow: [Card] = []
        var secondRow: [Card] = []
        var thirdRow: [Card] = []
        
        for columnArray in board {
            for var index = 0; index < columnArray.count;  index++ {
                let card = columnArray[index]
                if index == 0 {
                    firstRow.append(card)
                }
                else if index == 1 {
                    secondRow.append(card)
                }
                else if index == 2 {
                    thirdRow.append(card)
                }
                else {
                    println("Error")
                }
            }
        }
        
        var boardInRows:[[Card]] = [firstRow, secondRow, thirdRow]
        return boardInRows
    }
    
    class func computeWinnings(board:[[Card]]) -> Double {
        var boardInRows = unpackCardsIntoRows(board)
        var winnings = 0.0
        
        var flushWinCount = 0
        var prileWinCount = 0
        var straightWinCount = 0
        
        for row in boardInRows {
            if checkFlush(row) == true {
                println("Flush!")
                flushWinCount += 1
                winnings += 1.5
            }
            
            if checkStraight(row) == true {
                println("Straight!")
                straightWinCount += 1
                winnings += 3
            }
            
            if checkPrile(row) == true {
                println("Prile!")
                prileWinCount += 1
                winnings += 5
            }
            
        }
        
        if flushWinCount == 3 {
            println("Royal Flush!")
            winnings += 15
        }
        
        if straightWinCount == 3 {
            println("Epic Straight!")
            winnings += 1000
        }
        
        if prileWinCount == 3 {
            println("All Priles!")
            winnings += 250
        }
        
        
        return winnings
        
    }
    
    class func checkFlush(row:[Card]) -> Bool {
        let firstCard = row[0]
        let secondCard = row[1]
        let thirdCard = row[2]
        
        if firstCard.isRed == true && secondCard.isRed == true && thirdCard.isRed == true {
            return true
        }
        else if firstCard.isRed == false && secondCard.isRed == false && thirdCard.isRed == false {
            return true
        }
        else {
            return false
        }
        
    }
    
    class func checkStraight(row:[Card]) -> Bool {
        let firstCard = row[0]
        let secondCard = row[1]
        let thirdCard = row[2]
        
        if firstCard.value == secondCard.value - 1 && firstCard.value == thirdCard.value - 2 {
            return true
        }
        else if firstCard.value == secondCard.value + 1 && firstCard.value == thirdCard.value + 2 {
            return true
        }
        else {
            return false
        }
    }
    
    class func checkPrile(row:[Card]) -> Bool {
        let firstCard = row[0]
        let secondCard = row[1]
        let thirdCard = row[2]
        
        if firstCard.value == secondCard.value && firstCard.value == thirdCard.value {
            return true
        }
        else {
            return false
        }
        
    }
    
        
        
}
