//
//  Constants.swift
//  Number Tap
//
//  Created by jesse on 26/03/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import Foundation

public enum NotificationType {
    case ComeBack
    case Waited
}

enum gameMode: String {
    case Timed   = "Timed"
    case Endless = "Endless"
    case Memory  = "Memory"
}

// Use enum as a simple namespace.  (It has no cases so you can't instantiate it.)
public enum Products {
    
    /// TODO:  Change this to whatever you set on iTunes connect
    private static let Prefix = "com.flatboxstudio.numbertap."
    
    /// MARK: - Supported Product Identifiers
    public static let RemoveAds           = Prefix + "removeAds"
    
    // All of the products assembled into a set of product identifiers.
    private static let productIdentifiers: Set<ProductIdentifier> = [Products.RemoveAds]
    
    /// Static instance of IAPHelper that for rage products.
    public static let store = IAPHelper(productIdentifiers: Products.productIdentifiers)
}

/// Return the resourcename for the product identifier.
func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
    return productIdentifier.componentsSeparatedByString(".").last
}

struct k {
    
    private static let Prefix    = "com.flatboxstudio.numbertap."
    private static let wavEnding = ".wav"
    
    struct keys {
        
        static let adMobUnitID    = "ca-app-pub-2605361342491028/3787090995"
        static let cbAppId        = "56f6fd9c5b14536f8a31e503"
        static let cbAppSignature = "720d055366d319187a7ea370039704f5139c237f"
        static let ADAppID        = "appfd40158c251440d3a1"
        static let ADZoneIDs      = ["vze3c2eb0db7f0404eac"]
    }
    
    struct Sounds {
        
        static let blop01      = "blop01" + wavEnding
        static let blop02      = "blop02" + wavEnding

        static let blipBlop    = "blipBlop" + wavEnding

        static let blopAction1 = SKAction.playSoundFileNamed(blop01, waitForCompletion: false)
        static let blopAction2 = SKAction.playSoundFileNamed(blop02, waitForCompletion: false)
    }
    
    struct GameCenter {
        struct Leaderboard {
            
            static let TopScorers    = Prefix + "top_scorers"
            static let ShortestTimes = Prefix + "shortest_times"
            static let LongestRound  = Prefix + "longest_rounds"
            
        }
        
        struct Achivements {
            
            static let Points100  = Prefix + "100"
            static let Points500  = Prefix + "500"
            static let Points1k   = Prefix + "1000"
            static let Points10k  = Prefix + "10k"
            static let Points50k  = Prefix + "50k"
            static let Points100k = Prefix + "100k"
            static let Points500k = Prefix + "500k"
            static let Points1M   = Prefix + "1million"
            
        }
    }
}
