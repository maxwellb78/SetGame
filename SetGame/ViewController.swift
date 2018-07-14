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
    let colors = [UIColor.blue, UIColor.red, UIColor.purple]
    
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
        //for each Card Button set up the button
        for index in cardButtons.indices{
            //If Card has been dealt then show it
            if game.cardsDealt.contains(game.cards[index]){
                setButtonAttributesAndText(cardButtons[index], setNumberofSymbol(card: game.cards[index]), color: game.cards[index].color, shading: game.cards[index].shading)
                cardButtons[index].layer.cornerRadius = 8.0
                cardButtons[index].layer.borderWidth = 1.0
                cardButtons[index].layer.borderColor = UIColor.black.cgColor
            } else {
                clearButtonTitle(cardButtons[index])
                cardButtons[index].layer.cornerRadius = 8.0
                cardButtons[index].layer.borderWidth = 0
                cardButtons[index].layer.borderColor = UIColor.clear.cgColor
            }
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
    
    private func setButtonAttributesAndText(_ button: UIButton, _ text: String, color: Int, shading: Int){
        var attributes: [NSAttributedStringKey:Any] = [:]
        if shading == 0{
            // set to filled
            attributes[.strokeWidth] = -1
            attributes[.strokeColor] = colors[color]
            attributes[.foregroundColor] = colors[color].withAlphaComponent(1)
        } else if shading == 1{
            // set to stripped
            attributes[.foregroundColor] = colors[color].withAlphaComponent(0.3)
            attributes[.strokeColor] = colors[color]
        } else {
            // set to outlined
            attributes[.strokeWidth] = 8
            attributes[.strokeColor] = colors[color]
        }
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedString, for: UIControlState.normal)
    }
    
    private func clearButtonTitle(_ button: UIButton) {
        var attributes: [NSAttributedStringKey:Any] = [:]
        attributes[.strokeColor] = UIColor.clear.cgColor
        let attributedString = NSAttributedString(string: "", attributes: attributes)
        button.setAttributedTitle(attributedString, for: UIControlState.normal)
    }
    
    
}

