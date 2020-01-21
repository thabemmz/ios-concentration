//
//  ViewController.swift
//  Concentration
//
//  Created by Christiaan van Bemmel on 01/08/2019.
//  Copyright © 2019 Christiaan van Bemmel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let themes = [
        "animals": Theme(backgroundColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), cardBackgroundColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), emojis: "🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯"),
        "faces": Theme(backgroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), cardBackgroundColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), emojis: "😀😆😇😍😎🤓😫🤯🧐🥵"),
        "balls": Theme(backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardBackgroundColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), emojis: "⚽️🏀🏈⚾️🥎🎾🏐🏉🎱🍒"),
        "food": Theme(backgroundColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), cardBackgroundColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), emojis: "🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈"),
        "weather": Theme(backgroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), cardBackgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨"),
        "travel": Theme(backgroundColor: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), cardBackgroundColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), emojis: "🚗🚕🚙🚌🚎🏎🚓🚑🚒🚐")
    ]
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    private var emojiForCard = [Card:String]()
    lazy var theme = getRandomTheme()
    var numberOfPairsOfCards: Int {
        // Add one extra card in the game to make sure we also match uneven cases
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction private func clickNewGame(_ sender: UIButton) {
        startNewGame()
    }
    
    override func viewDidLoad() {
        // Apply theme styling
        updateBackgroundColor()
        updateViewFromModel()
    }
    
    private func startNewGame() {
        game = Concentration(numberOfPairsOfCards: cardButtons.count / 2)
        theme = getRandomTheme()
        emojiForCard = [Card:String]()
        updateBackgroundColor()
        updateViewFromModel()
    }

    private func getRandomTheme() -> Theme {
        let availableThemes = Array(themes.values)
        return availableThemes[availableThemes.count.arc4random]
    }
    
    private func updateBackgroundColor() {
        view.backgroundColor = theme.backgroundColor
    }
    
    private func updateViewFromModel() {
        // update flipcount
        let flipCountAttributeStringAttrs: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: flipCountAttributeStringAttrs)
        flipCountLabel.attributedText = attributedString

        // update score
        scoreLabel.text = "Score: \(game.score)"
        
        // update cards
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : theme.cardBackgroundColor
            }
        }
    }
    
    private func emoji(for card: Card) -> String {
        if theme.emojis.count > 0, emojiForCard[card] == nil {
            let randomStringIndex = theme.emojis.index(theme.emojis.startIndex, offsetBy: theme.emojis.count.arc4random)
            emojiForCard[card] = String(theme.emojis.remove(at: randomStringIndex))
        }
        
        return emojiForCard[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        
        if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        
        return 0
    }
}
