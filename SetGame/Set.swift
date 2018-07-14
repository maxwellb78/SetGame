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
    private(set) var cardsSelected = [Card]()
    private(set) var cardsMatched = [Card]()
    
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
    
    mutating func chooseCard(at index: Int){
        //If card is not dealt ignore
        if !cardsDealt.contains(cards[index]){
            return
        }
        
        //If card is matched ignore
        if cardsMatched.contains(cards[index]){
            return
        }
        
        //Lets just select and deselect cards to start
        if !cardsSelected.contains(cards[index]){
            //Only select a card if less than 3 are selected already
            if (cardsSelected.count < 3){
                cardsSelected.append(cards[index])
            }
        } else {
            if let selectedCardIndex = cardsSelected.index(of: cards[index]) {
                cardsSelected.remove(at: selectedCardIndex)
            }
        }
        
        //If 3 cards selected chcek for match
        if cardsSelected.count == 3 {
            checkForMatch(firstCard: cardsSelected[0], secondCard: cardsSelected[1], thridCard: cardsSelected[2])
        }
        
    }
    
    private mutating func checkForMatch(firstCard: Card, secondCard: Card, thridCard: Card){
        //For a match all:
        //    Sybmols must be same or different
        //    Colors must be same or different
        //    Number of Symbols must be some or different
        //    Shading must be same or different
        if (isOneElementMatched(cardOne: firstCard.symbol, cardTwo: secondCard.symbol, cardThree: thridCard.symbol) &&
            isOneElementMatched(cardOne: firstCard.color, cardTwo: secondCard.color, cardThree: thridCard.color) &&
            isOneElementMatched(cardOne: firstCard.numberOfSymbols, cardTwo: secondCard.numberOfSymbols, cardThree: thridCard.numberOfSymbols) &&
            isOneElementMatched(cardOne: firstCard.shading, cardTwo: secondCard.shading, cardThree: thridCard.shading)){
            //Matched move from Selected to Match
            cardsMatched.append(contentsOf: cardsSelected)
            cardsSelected.removeAll()
        } else {
            
        }
        
    }
    
    private func isOneElementMatched(cardOne one: Int, cardTwo two: Int, cardThree three: Int) -> Bool {
        // if all are the same
        if (one == two && two == three) {
            return true
        }
        // if all are different
        if (one != two && one != three && two != three){
            return true
        }
        return false
    }
    
    init() {
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
        
        //Shuffle the cards
        var shuffledCards = [Card]()
        for _ in cards.indices {
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
