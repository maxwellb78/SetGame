//
//  ViewController.swift
//  SetGame
//
//  Created by Bryon Maxwell on 7/10/18.
//  Copyright © 2018 CDN  Consulting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = Set(maxCardsDisplayed: cardButtons.count)
    private let aspectRatio = CGFloat(0.71)
    private lazy var grid = Grid.init(layout: Grid.Layout.aspectRatio(aspectRatio), frame: cardAreaView.bounds)
    let symbols = ["▲", "●", "■"]
    let colors = [UIColor.blue, UIColor.red, UIColor.purple]
    
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var numberOfMatchesLabel: UILabel!
    @IBOutlet weak var cardAreaView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startNewGame()
    }
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        startNewGame()
    }

    private func startNewGame() {
        game = Set(maxCardsDisplayed: Set.numberOfCardsInGame)
        //Start the game by dealing 12 cards
        game.dealCards(numberOfCards: 12)
        updateViewFromModel()
    }
    
    @IBOutlet var cardButtons: [UIButton]!

    private func updateViewFromModel(){
        //If there is a new number of cards reset the Grid
        if grid.cellCount != game.cardsDealtDict.count {
            grid.cellCount = game.cardsDealtDict.count
        }
        
        for view in cardAreaView.subviews {
            view.removeFromSuperview()
        }
        
        for index in 0..<grid.cellCount {
            if let cardRect = grid[index] {
                if let card = game.cardsDealtDict[index]{
                    
                    let cardView = CardView(frame: cardRect)
                    cardView.symbol = card.symbol
                    cardView.color = card.color
                    cardView.numberOfSymbols = card.numberOfSymbols
                    cardView.shading = card.shading
                    if game.cardsSelected.contains(card) {
                        cardView.isSelected = true
                    }
                    if let bgColor = cardAreaView.backgroundColor {
                        cardView.superViewBackgroundColor = bgColor
                    }
                    cardView.sizeToFit()
                    cardAreaView.addSubview(cardView)
                }
            }
        }
        
        
        
        //Set the Title for Deal Cards Button
        if game.cards.isEmpty {
            dealButton.setTitle("No cards left", for: UIControlState.normal)
        } else {
            dealButton.setTitle("Deal More Cards", for: UIControlState.normal)
        }
    }
    
    
    private func OLDupdateViewFromModel(){
 
        //for each Card Button set up the button
        for index in cardButtons.indices{
            let cardButton = cardButtons[index]
            cardButton.layer.cornerRadius = 8.0
            
            //Get the card for the cardButton
            //if game.cardsDealt.contains(card)
            if let card = game.cardsDealtDict[index]{
                
                //Layout the card
                setButtonAttributesAndText(cardButton, setNumberofSymbol(card: card), color: card.color, shading: card.shading)
                
                //Set the card border for matched and selected
                if game.cardsSelected.contains(card) {
                    cardButton.layer.borderWidth = 5.0
                    cardButton.layer.borderColor = UIColor.red.cgColor
                    cardButton.layer.backgroundColor = UIColor.clear.cgColor
                } else {
                    cardButton.layer.borderWidth = 1.0
                    cardButton.layer.borderColor = UIColor.black.cgColor
                    cardButton.layer.backgroundColor = UIColor.clear.cgColor
                }
            } else {
                clearButtonTitle(cardButton)
                cardButton.layer.borderWidth = 0
                cardButton.layer.borderColor = UIColor.clear.cgColor
                cardButton.layer.backgroundColor = UIColor.clear.cgColor
            }
            
            numberOfMatchesLabel.text = "Matches: \(game.numberOfMatches)"
        }
        
        
        //Set the Title for Deal Cards Button
        if game.cards.isEmpty {
            dealButton.setTitle("No cards left", for: UIControlState.normal)
        } else if cardButtons.count == game.cardsDealtDict.count {
            dealButton.setTitle("No spaces left for cards", for: UIControlState.normal)
        } else {
            dealButton.setTitle("Deal More Cards", for: UIControlState.normal)
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
    
    @IBAction func touchCardButton(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else{
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction func touchDealMoreCards(_ sender: UIButton) {
        //Deal 3 more cards
        game.dealThreeCards()
        updateViewFromModel()
    }
}
