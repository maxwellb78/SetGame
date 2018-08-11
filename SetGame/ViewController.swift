//
//  ViewController.swift
//  SetGame
//
//  Created by Bryon Maxwell on 7/10/18.
//  Copyright © 2018 CDN  Consulting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = Set(maxCardsDisplayed: 0)
    private let aspectRatio = CGFloat(0.71)
    private lazy var grid = Grid.init(layout: Grid.Layout.aspectRatio(aspectRatio), frame: cardAreaView.bounds)
    
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var numberOfMatchesLabel: UILabel!
    @IBOutlet weak var cardAreaView: UIView! {
        didSet{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(shuffleCards(_:)))
            swipe.direction = [.left,.right]
            cardAreaView.addGestureRecognizer(swipe)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startNewGame()
    }
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        startNewGame()
    }

    private func startNewGame() {
        game = Set(maxCardsDisplayed: Set.numberOfCardsInGame)
        game.dealCards(numberOfCards: 81)
        updateViewFromModel()
    }

    private func updateViewFromModel(){
        grid.cellCount = game.cardsDealtDict.count
        
        //remove any cards alreaey in the view
        for view in cardAreaView.subviews {
            view.removeFromSuperview()
        }
        
        
        print("-------------")
        for index in 0...100 {
             if let card = game.cardsDealtDict[index]{
                print("index: \(index) card: \(card)")
            }
        }
        print("**************")
        
        var cardDealtIndex = 0
        for index in 0..<grid.cellCount {
            if let cardRect = grid[index] {
                cardDealtIndex = nextDealtCard(cardDealtIndex)
                print("index: \(index)  cardDealtIndex: \(cardDealtIndex)")
                if let card = game.cardsDealtDict[cardDealtIndex]{
                    print("card: \(card)")
                    
                    
                    let cardView = CardView(frame: cardRect)
                    cardView.symbol = card.symbol
                    cardView.color = card.color
                    cardView.numberOfSymbols = card.numberOfSymbols
                    cardView.shading = card.shading
                    cardView.cardNumber = index
                    if game.cardsSelected.contains(card) {
                        cardView.isSelected = true
                    }
                    if let bgColor = cardAreaView.backgroundColor {
                        cardView.superViewBackgroundColor = bgColor
                    }
                    cardView.sizeToFit()
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchCard(_:)))
                    tapGesture.numberOfTapsRequired = 1
                    tapGesture.numberOfTouchesRequired = 1
                    cardView.addGestureRecognizer(tapGesture)
                    
                    cardAreaView.addSubview(cardView)
                }
            }
            cardDealtIndex += 1
        }
        
        //Set Matches Text
        numberOfMatchesLabel.text = "Matches: \(game.numberOfMatches)"
        
        //Set the Title for Deal Cards Button
        if game.cards.isEmpty {
            dealButton.setTitle("No cards left", for: UIControlState.normal)
        } else {
            dealButton.setTitle("Deal More Cards", for: UIControlState.normal)
        }
    }
    
    private func nextDealtCard(_ cardDealtIndex: Int) -> Int {
        let maxIndex = cardDealtDictMaxIndex()
        for index in cardDealtIndex...maxIndex {
            if game.cardsDealtDict[index] != nil{
                return index
            }
        }
        return maxIndex + 10
    }
    
    private func cardDealtDictMaxIndex() -> Int{
        var returnIndex = 0
        
        for (index, card) in game.cardsDealtDict {
            if index > returnIndex {
                returnIndex = index
            }
        }
        return returnIndex
    }
    
    @objc func touchCard(_ sender: UITapGestureRecognizer){
        if let cardView = sender.view as? CardView {
            game.chooseCard(at: cardView.cardNumber)
            updateViewFromModel()
        }
    }
    
    @objc func shuffleCards(_ sender: UISwipeGestureRecognizer){
        game.shuffleCards()
        updateViewFromModel()
    }
    
    private func clearButtonTitle(_ button: UIButton) {
        var attributes: [NSAttributedStringKey:Any] = [:]
        attributes[.strokeColor] = UIColor.clear.cgColor
        let attributedString = NSAttributedString(string: "", attributes: attributes)
        button.setAttributedTitle(attributedString, for: UIControlState.normal)
    }
    
    @IBAction func touchDealMoreCards(_ sender: UIButton) {
        //Deal 3 more cards
        game.dealThreeCards()
        updateViewFromModel()
    }
}
