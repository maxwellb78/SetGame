//
//  Card.swift
//  SetGame
//
//  Created by Bryon Maxwell on 7/11/18.
//  Copyright © 2018 CDN  Consulting. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int { return identifier }
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    let symbol: Int
    let shading: Int
    let color: Int
    let numberOfSymbols: Int
    
    private var identifier: Int
    private static var indentifierFactory = 0
    private static func getUniqueIdentifier() -> Int{
        indentifierFactory += 1
        return indentifierFactory
    }
    
    init(symbol: Int, shading: Int, color: Int, numberOfSymbols: Int){
        self.symbol = symbol
        self.shading = shading
        self.color = color
        self.numberOfSymbols = numberOfSymbols
        identifier = Card.getUniqueIdentifier()
    }
    
}
