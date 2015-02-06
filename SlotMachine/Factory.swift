//
//  Factory.swift
//  SlotMachine
//
//  Created by Ben Blanchard on 06/02/2015.
//  Copyright (c) 2015 Ben Blanchard. All rights reserved.
//

import Foundation
import UIKit

class Factory {
    class func createCards() -> [[Card]] {
        let kNumberOfRows = 3
        let kNumberOfColumns = 3
        
        var board: [[Card]] = []
        for var columnNumber = 0; columnNumber < kNumberOfColumns; ++columnNumber {
            var columnArray:[Card] = []
            for var rowNumber = 0; rowNumber < kNumberOfRows; ++rowNumber {
                var card = Factory.createCard(columnArray)
                columnArray.append(card)
            }
            board.append(columnArray)
            
            
        }
        return board
    }
    
    class func createCard(currentCards:[Card]) -> Card {
        var currentCardValues:[Int] = []
        for card in currentCards {
            currentCardValues.append(card.value)
        }
        
        var randomNumber = Int(arc4random_uniform(UInt32(13)))
        while contains(currentCardValues, randomNumber+1) {
            randomNumber = Int(arc4random_uniform(UInt32(13)))
        }
        
        var card:Card
        
        switch randomNumber {
        case 0: card = Card(value: 1, image:  UIImage(named:"Ace"), isRed: true)
        case 1: card = Card(value: 2, image: UIImage(named:"Two"), isRed: true)
        case 2: card = Card(value: 3, image:  UIImage(named:"Three"), isRed: true)
        case 3: card = Card(value: 4, image: UIImage(named:"Four"), isRed: true)
        case 4: card = Card(value: 5, image:  UIImage(named:"Five"), isRed: false)
        case 5: card = Card(value: 6, image: UIImage(named:"Six"), isRed: false)
        case 6: card = Card(value: 7, image:  UIImage(named:"Seven"), isRed: true)
        case 7: card = Card(value: 8, image: UIImage(named:"Eight"), isRed: false)
        case 8: card = Card(value: 9, image:  UIImage(named:"Nine"), isRed: false)
        case 9: card = Card(value: 10, image: UIImage(named:"Ten"), isRed: true)
        case 10: card = Card(value: 11, image:  UIImage(named:"Jack"), isRed: false)
        case 11: card = Card(value: 12, image: UIImage(named:"Queen"), isRed: false)
        case 12: card = Card(value: 13, image:  UIImage(named:"King"), isRed: true)
        default: card = Card(value: 0, image: UIImage(named:"Ace"), isRed: true)
        }
            
        return card

    }
    

}
