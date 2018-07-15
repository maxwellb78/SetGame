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
    private(set) var cardsDealtDict: [Int : Card] = [:]
    private(set) var cardsSelected = [Card]()
    private(set) var maxCardsDisplayed = 0
    private(set) var numberOfMatches = 0
    
    mutating func dealCards(numberOfCards number: Int){
        for index in 0..<number {
            if cards.count > 0 {
               // cardsDealt.append(cards[0])
                cardsDealtDict.updateValue(cards[0], forKey: index)
                cards.remove(at: 0)
            } else {
                return
            }
        }
    }
    
    mutating func dealThreeCards(){
        dealCard()
        dealCard()
        dealCard()
    }
    
    mutating func dealCard(){
        if cards.count > 0 {
            for index in 0...maxCardsDisplayed - 1 {
                if cardsDealtDict[index] == nil {
                    cardsDealtDict.updateValue(cards[0], forKey: index)
                    cards.remove(at: 0)
                    return
                }
            }
        }
    }
    
    func haveAllCardsBeenDealt() -> Bool{
        return cards.count == 0 ? true : false
    }
    
    mutating func chooseCard(at index: Int){
        //If card is not dealt ignore
        if let card = cardsDealtDict[index] {
            
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
                
                //For a match all:
                //    Sybmols must be same or different
                //    Colors must be same or different
                //    Number of Symbols must be some or different
                //    Shading must be same or different
                if (isOneElementMatched(cardOne: cardsSelected[0].symbol, cardTwo: cardsSelected[1].symbol, cardThree: cardsSelected[2].symbol) &&
                    isOneElementMatched(cardOne: cardsSelected[0].color, cardTwo: cardsSelected[1].color, cardThree: cardsSelected[2].color) &&
                    isOneElementMatched(cardOne: cardsSelected[0].numberOfSymbols, cardTwo: cardsSelected[1].numberOfSymbols, cardThree: cardsSelected[2].numberOfSymbols) &&
                    isOneElementMatched(cardOne: cardsSelected[0].shading, cardTwo: cardsSelected[1].shading, cardThree: cardsSelected[2].shading)){

                    //Matched move from Selected to Match
                    removeCardsFromDealt(cardsSelected)
                    cardsSelected.removeAll()
                    dealThreeCards()
                    numberOfMatches += 1
                } else {
                    //No Match deselect all cards and only select the card just touched
                    cardsSelected.removeAll()
                    cardsSelected.append(card)
                }
                
                //Use this for testing without matching
                //Matched move from Selected to Match
//                removeCardsFromDealt(cardsSelected)
//                cardsSelected.removeAll()
//                dealThreeCards()
//                numberOfMatches += 1
                
            }
        }
    }
    
    private mutating func removeCardsFromDealt(_ cards: [Card]){
        for (cardNumber, card) in cardsDealtDict {
            if cards.contains(card){
                cardsDealtDict.removeValue(forKey: cardNumber)
            }
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

