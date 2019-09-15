//
//  CardModel.swift
//  MatchApp
//
//  Created by Cooper Strahan on 9/14/19.
//  Copyright © 2019 Cooper Strahan. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card]
    {
        // Declare an array to store generated cards
        var generatedCardsArray = [Card]()
        var numbersArray = [UInt32]()
        // Randomly generate pairs of cards
        while generatedCardsArray.count < 16
        {
            let randomNumber = arc4random_uniform(13) + 1
            
            if !numbersArray.contains(randomNumber)
            {
                print(randomNumber)
                numbersArray.append(randomNumber)
                
                let cardOne = Card(cardName: "card\(randomNumber)")
                generatedCardsArray.append(cardOne)
                
                let cardTwo = Card(cardName: "card\(randomNumber)")
                generatedCardsArray.append(cardTwo)
            }
        }
        
        // Randomize the array
        for i in 0...generatedCardsArray.count-1
        {
            let rand = Int(arc4random_uniform(UInt32(generatedCardsArray.count-1)) + 1)
            
            let temp = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[rand]
            generatedCardsArray[rand] = temp
        }
        
        // Return the array
        return generatedCardsArray
    }
}
