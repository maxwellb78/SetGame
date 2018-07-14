//
//  ViewController.swift
//  SetGame
//
//  Created by Bryon Maxwell on 7/10/18.
//  Copyright © 2018 CDN  Consulting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //private lazy var game = Set(numberOfPairsOfCards: numberOfPairsOfCards)
    private lazy var game = Set(numberOfCardInGame: 0)
    let symbols = ["▲", "●", "■"]
    let colors = [#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)]
    let c = [UIColor.green, UIColor.red, UIColor.purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        startNewGame()
    }

    private func startNewGame() {
        game = Set(numberOfCardInGame: cardButtons.count)
        //Start the game by dealing 12 cards
        game.dealCards(numberOfCards: 12)
        updateViewFromModel()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    private func updateViewFromModel(){        
        for index in 0...23 {
            let cardButton = cardButtons[index]
            setButtonAttributesAndText(cardButton, setNumberofSymbol(card: game.cards[index]), color: game.cards[index].color, shading: game.cards[index].shading)
            cardButton.layer.cornerRadius = 8.0
            cardButton.layer.borderWidth = 1.0
            cardButton.layer.borderColor = UIColor.black.cgColor
        }
        
    }
    
    private func setNumberofSymbol(card: Card) -> String{
        let symbol = symbols[card.symbol]
        var title = ""
        for _ in 0...card.numberOfSymbols{
            title += symbol
        }
        return title
    }
    
    private func setButtonAttributesAndText(_ title: UIButton, _ text: String, color: Int, shading: Int){
        var attributes: [NSAttributedStringKey:Any] = [:]
        if shading == 0{
            // set to filled
            attributes[.strokeWidth] = -1
            attributes[.strokeColor] = c[color]
            attributes[.foregroundColor] = c[color].withAlphaComponent(1)
        } else if shading == 1{
            // set to stripped
            attributes[.foregroundColor] = c[color].withAlphaComponent(0.15)
            attributes[.strokeColor] = c[color]
        } else {
            // set to outlined
            attributes[.strokeWidth] = 8
            attributes[.strokeColor] = c[color]
        }
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        title.setAttributedTitle(attributedString, for: UIControlState.normal)
        //title.setattributedText = attributedString
    }
    
    
}

