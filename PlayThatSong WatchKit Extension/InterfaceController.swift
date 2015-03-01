//
//  InterfaceController.swift
//  PlayThatSong WatchKit Extension
//
//  Created by Diego Guajardo on 1/03/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import WatchKit
import Foundation

let key = "FunctionRequestKey"

class InterfaceController: WKInterfaceController {
    
    // MARK: - PROPERTIES
    
    // MARK: IBOutlets
    
    @IBOutlet weak var songTitleLabel: WKInterfaceLabel!
    
    // MARK: - BODY
    
    // MARK: Initialisers

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: IBActions
    
    @IBAction func previousSongButtonPressed() {
    }
    
    @IBAction func nextSongButtonPressed() {
    }
    
    @IBAction func playSongButtonPressed() {
        // Open the parent application, pass in some information to the AppDelegate and get a reply back. The reply will be a Block, so it can be stored (in the WatchKitInfo class) by the AppDelegate
        
        var info = [key : "SomeOtherValue"]
        
        WKInterfaceController.openParentApplication(info, reply: { (reply, error) -> Void in
            println("Reply: \(reply), error: \(error)")
        })
    }

}
