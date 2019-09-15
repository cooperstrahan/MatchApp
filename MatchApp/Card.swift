//
//  Card.swift
//  MatchApp
//
//  Created by Cooper Strahan on 9/14/19.
//  Copyright © 2019 Cooper Strahan. All rights reserved.
//

import Foundation

class Card {
    var imageName = ""
    var isFlipped = false
    var isMatched = false
    
    init(cardName: String){
        imageName = cardName
    }
}
