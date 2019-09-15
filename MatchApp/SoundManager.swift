//
//  SoundManager.swift
//  MatchApp
//
//  Created by Cooper Strahan on 9/15/19.
//  Copyright © 2019 Cooper Strahan. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect
    {
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect:SoundEffect)
    {
        var soundFilename = ""
        
        // Determine which sound effect we want to play
        // Set the appropriate sound effect
        
        switch effect {
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
        }
        
        // Get the path to the sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else
        {
            print("Couldn't find sound file \(soundFilename)")
            return
        }
        
        // Create a URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do
        {
            // Create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            //Play sound
            audioPlayer?.play()
            
        } catch
        {
            //Couldn't create audio player object, log the error
            print("Couldn't create the audo player object for sound file \(soundFilename)")
        }
    }
}
