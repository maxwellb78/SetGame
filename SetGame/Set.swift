//
//  Set.swift
//  SetGame
//
//  Created by Bryon Maxwell on 7/11/18.
//  Copyright © 2018 CDN  Consulting. All rights reserved.
//

import Foundation

struct Set {
    static let numberOfCardsInGame = 81
    private(set) var cards = [Card]()
//    private(set) var cardsDealtDict: [Int : Card] = [:]
    private(set) var cardsDealt = [Card]()
    private(set) var cardsSelected = [Card]()
    private(set) var maxCardsDisplayed = 0
    private(set) var numberOfMatches = 0
    
    mutating func dealCards(numberOfCards number: Int){
        for _ in 0..<number {
            if cards.count > 0 {
                cardsDealt.append(cards[0])
                cards.remove(at: 0)
            } else {
                return
            }
        }
    }
    
    mutating func dealThreeCards(){
        for _ in 1...3 {
            dealCard()
        }
    }
    
    mutating func dealCard(){
        if cards.count > 0 {
            cardsDealt.append(cards[0])
            cards.remove(at: 0)
        }
    }
    
    mutating func replaceCards(forCards cards: [Card]){
        for card in cards {
            if let cardIndex = cardsDealt.index(of: card) {
                if self.cards.count > 0{
                    cardsDealt.insert(self.cards[0], at: cardIndex)
                    cardsDealt.remove(at: cardIndex + 1)
                    self.cards.remove(at: 0)
                } else {
                    cardsDealt.remove(at: cardIndex)
                }
            }
        }
    }
    
    func haveAllCardsBeenDealt() -> Bool{
        return cards.count == 0 ? true : false
    }
    
    mutating func chooseCard(at index: Int){
        //If card is not dealt ignore
        //if let card = cardsDealtDict[index] {
    
        if index < cardsDealt.count {
            let card = cardsDealt[index]

            //Lets just select and deselect cards to start
            if !cardsSelected.contains(card){
                //Only select a card if less than 3 are selected already
                if (cardsSelected.count < 3){
                    cardsSelected.append(card)
                }
            } else {
                if let selectedCardIndex = cardsSelected.index(of: card) {
                    cardsSelected.remove(at: selectedCardIndex)
                }
            }
            
            //If 3 cards selected chcek for match
            if cardsSelected.count == 3 {
                // USE THIS FOR TESTING
                //                if areThreeCardsAMatch(cardOne: cardsSelected[0], cardTwo: cardsSelected[0], cardThree: cardsSelected[0]) {
                if areThreeCardsAMatch(cardOne: cardsSelected[0], cardTwo: cardsSelected[1], cardThree: cardsSelected[2]) {
                    replaceCards(forCards: cardsSelected)
                    cardsSelected.removeAll()
                    numberOfMatches += 1
                } else {
                    //No Match deselect all cards and only select the card just touched
                    cardsSelected.removeAll()
                    cardsSelected.append(card)
                }
            }
        }
    }
    
    private mutating func removeCardsFromDealt(_ cards: [Card]){
        for card in cards {
            if let cardIndex = cardsDealt.index(of: card) {
                cardsDealt.remove(at: cardIndex)
            }
        }
        
    }
    
    private func areThreeCardsAMatch(cardOne one: Card, cardTwo two: Card, cardThree three: Card) -> Bool {
        //For a match all:
        //    Sybmols must be same or different
        //    Colors must be same or different
        //    Number of Symbols must be some or different
        //    Shading must be same or different
        return isOneElementMatched(cardOne: one.symbol, cardTwo: two.symbol, cardThree: three.symbol) &&
            isOneElementMatched(cardOne: one.color, cardTwo: two.color, cardThree: three.color) &&
            isOneElementMatched(cardOne: one.numberOfSymbols, cardTwo: two.numberOfSymbols, cardThree: three.numberOfSymbols) &&
        isOneElementMatched(cardOne: one.shading, cardTwo: two.shading, cardThree: three.shading) ? true : false
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
    
    init(maxCardsDisplayed: Int) {
        self.maxCardsDisplayed = maxCardsDisplayed
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
        cards = shuffleCards(cards)
    }
    
    mutating func shuffleDealtCards(){
        cardsDealt = shuffleCards(cardsDealt)
    }
    
    private mutating func shuffleCards(_ cardsToBeShuffled: [Card]) -> [Card]{
        var toBeShuffled = cardsToBeShuffled
        var shuffledCards = [Card]()
        for _ in toBeShuffled.indices {
            let randomIndex = toBeShuffled.count.arc4random
            shuffledCards.append(toBeShuffled.remove(at: randomIndex))
        }
        return shuffledCards
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

