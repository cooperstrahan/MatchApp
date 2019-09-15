//
//  ViewController.swift
//  MatchApp
//
//  Created by Cooper Strahan on 9/14/19.
//  Copyright © 2019 Cooper Strahan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 60 * 1000 // 10 Seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call getCards method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create Timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    // MARK: - Timer Methods
    
    @objc func timerElapsed()
    {
        milliseconds -= 1
        
        // Convert to Seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // Set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        //When the timer has reached 0...
        if milliseconds <= 0
        {
            timer?.invalidate()
            
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
    }
    
    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a CardCollectionViewCell Object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // Set the card's front image view to the correct card
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there is any time left
        if milliseconds <= 0
        {
            return
        }
        
        // Get the cell the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false
        {
            // Flip the card
            cell.flip()
            
            //Play the flip sound
            SoundManager.playSound(.flip)
            
            card.isFlipped = true
            
            // Determine if it's the first or second card being flipped over
            if firstFlippedCardIndex == nil
            {
                firstFlippedCardIndex = indexPath
            } else
            {
                checkForMatches(indexPath)
            }
        }
    } //End of DidSelectItemAtMethod
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath)
    {
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName
        {
            // It's a match
            
            // Play sound
            SoundManager.playSound(.match)
            
            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards left unmatched
            checkGameEnded()
            
        } else
        {
            // Not a match
            
            // Play sound
            SoundManager.playSound(.nomatch)
            
            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Tell the collectionview to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
        
    } // End of check for matches method
    
    func checkGameEnded()
    {
        // Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray
        {
            if card.isMatched == false
            {
                isWon = false
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        // If not user has won stop the timer
        if isWon == true
        {
            if milliseconds > 0
            {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won"
        
        } else
        {
        // If so check if there is any time left
            if milliseconds > 0
            {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        showAlert(title, message)
    }
    
    func showAlert(_ title: String, _ message: String)
    {
        // Show won/lost messaging
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }

} //End of ViewController Class

