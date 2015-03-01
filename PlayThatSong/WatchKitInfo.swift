//
//  WatchKitInfo.swift
//  PlayThatSong
//
//  Created by Diego Guajardo on 1/03/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import Foundation

let key = "FunctionRequestKey"

class WatchKitInfo {
    // In this class we will store the block of code that is sent from the AppDelegate so we can reference this class whenever we need rather than have to call AppDelegate every time
    
    // This is of the same type as the 'reply' variable received by the 'handleWatchKitExtensionRequest' function in AppDelegate
    var replyBlock: ([NSObject : AnyObject]!) -> Void
    var playerRequest: String?
    
    // Init will get two variables of the same type as the 'userInfo' and the 'reply' variables received by the 'handleWatchKitExtensionRequest' function in AppDelegate
    init(playerDictionary: [NSObject : AnyObject], reply: ([NSObject : AnyObject]!) -> Void) {
        
        if let playerDictionary = playerDictionary as? [String : String] {
            // If let means that if playerDictionary is NOT nil, then specify that the playerDictionary (which is an optional) is of type [String : String]
            self.playerRequest = playerDictionary[key]
        } else {
            println("No Information Error")
        }
        
        self.replyBlock = reply
    }
}