//
//  Set.swift
//  SetGame
//
//  Created by Bryon Maxwell on 7/11/18.
//  Copyright © 2018 CDN  Consulting. All rights reserved.
//

import Foundation

struct Set {
    private(set) var cards = [Card]()
    private(set) var cardsDealt = [Card]()
    
    mutating func dealCards(numberOfCards number: Int){
        var count = number
        while count > 0 {
            let index = cards.count.arc4random
            if !cardsDealt.contains(cards[index]){
                let card = cards[index]
                cardsDealt.append(card)
                count -= 1
            }
            if haveAllCardsBeenDealt() {
                count = 0
            }
        }
    }
    
    func haveAllCardsBeenDealt() -> Bool{
        for index in cards.indices{
            if !cardsDealt.contains(cards[index]){
                return false
            }
        }
        return true
    }
    
    init(numberOfCardInGame: Int) {
        for symbolIndex in 0...2 {
            for shadingIndex in 0...2 {
                for colorIndex in 0...2 {
                    for numberOfSymbolIndex in 0...2 {
                        let card = Card(symbol: symbolIndex, shading: shadingIndex, color: colorIndex, numberOfSymbols: numberOfSymbolIndex)
                        cards += [card]
                    }
                }
            }
        }
        
        
        //Shuffle the cards and only use the number of cards in the game
        var shuffledCards = [Card]()
        for _ in 1...numberOfCardInGame {
            let randomIndex = cards.count.arc4random
            shuffledCards.append(cards.remove(at: randomIndex))
        }
        cards = shuffledCards
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
}
