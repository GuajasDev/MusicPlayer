//
//  ViewController.swift
//  PlayThatSong
//
//  Created by Diego Guajardo on 1/03/2015.
//  Copyright (c) 2015 GuajasDev. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: IBOutlets

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentSongLabel: UILabel!
    
    // MARK: Variables
    
    // AVFoundation
    var audioSession: AVAudioSession!   // AVAudioSession is a singleton
    var audioQueuePlayer: AVQueuePlayer!
    // ----- This was replaced by the AudioQueuePlayer -----
//    var audioPlayer: AVAudioPlayer!
    
    var currentSongIndex: Int!
    
    // MARK: - BODY
    
    // MARK: Initialisers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureAudioSession()
        self.configureAudioQueuePlayer()
        
        // Listen for the notification created by the AppDelegate, which passes an object of type WatchKitInfo (instantiated in AppDelegate), which stores the information sent by the Watch InterfaceController. Pretty chill...
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleRequest:"), name: "WatchKitDidMakeRequest", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBActions
    
    @IBAction func playButtonPressed(sender: UIButton) {
        self.playMusic()
        self.updateUI()
    }
    
    @IBAction func playPreviousButtonPressed(sender: UIButton) {
        // There isn't an easy way to go to a previous song, so we'll figure it out ;)
        
        if currentSongIndex > 0 {
            // We are not listening to the first song
            
            // Make sure the song is not playing for when we start making changes
            self.audioQueuePlayer.pause()
            
            // Adjust the time of the AudioPlayer. Reset everything to time zero
            self.audioQueuePlayer.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            
            // Create constants to store the currentSongIndex and the list of songs
            let temporaryNowPlayIndex = self.currentSongIndex
            let temporaryPlayList = self.createSongs()
            
            // Remove all the songs that were stored in the audioQueuePlayer
            self.audioQueuePlayer.removeAllItems()
            
            // Add items back to the audioQueuePlayer
            for var index = temporaryNowPlayIndex - 1; index < temporaryPlayList.count; index++ {
                // Even though temporaryPlayList is an array in which all elements are AVPlayerItems, it is specified as an array of [AnyObject]. Because insertItem needs an AVPlayerItem, we specify that it is using the 'as' keyword
                self.audioQueuePlayer.insertItem(temporaryPlayList[index] as AVPlayerItem, afterItem: nil)
            }
            
            // Save the new currentSongIndex
            self.currentSongIndex = temporaryNowPlayIndex - 1
            
            // Re-Adjust the time of the AudioPlayer. Reset everything to time zero. A bit odd, but we have to do it...
            self.audioQueuePlayer.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            
            // Play!
            self.audioQueuePlayer.play()
        }
        
        self.updateUI()
    }
    
    @IBAction func playNextButtonPressed(sender: UIButton) {
        self.currentSongIndex = self.currentSongIndex + 1
        self.audioQueuePlayer.advanceToNextItem()
        self.updateUI()
    }
    
    // MARK: Audio
    
    func configureAudioSession() {
        
        // Initialise like this since it is a singleton
        self.audioSession = AVAudioSession.sharedInstance()
        
        // NSError only gets initialised if there actually is an error
        var categoryError: NSError?
        var activeError: NSError?
        
        // Setup the category for our AudioSession. Remember that the '&" in the error name means that we are not passing the actuall NSError, we are passing the MEMORY LOCATION of the NSError, so if there is an error it can be stored in there
        self.audioSession.setCategory(AVAudioSessionCategoryPlayback, error: &categoryError)
        
        // Setup the active state
        var success = self.audioSession.setActive(true, error: &activeError)
        
        if !success {
            println("Error making ausio session active \(activeError)")
        }
    }
    
    // ----- This was replaced by the audioQueuePlayer -----
//    func configureAudioPlayer() {
//        
//        // Create a file path using NSBundle
//        var songPath = NSBundle.mainBundle().pathForResource("Open Source - Sending My Signal", ofType: "mp3")
//        
//        // Create a URL
//        var songURL = NSURL.fileURLWithPath(songPath!)
//        
//        println("Song URL: \(songURL)")
//        
//        // Guve audioPlayer the songURL so it know which song to play
//        var songError: NSError?
//        self.audioPlayer = AVAudioPlayer(contentsOfURL: songURL, error: &songError)
//        
//        // Plays the song once. If we want an infinite loop we just need to put in a negative number
//        self.audioPlayer.numberOfLoops = 0
//    }
    
    func configureAudioQueuePlayer() {
        
        // Get the songs
        let songs = createSongs()
        
        // Initiate the audioQueuePlayer
        self.audioQueuePlayer = AVQueuePlayer(items: songs)
        
        // Add a MSMotification to each song so we know whn a song finishes playing (ie it played till the end)
        for var songIndex = 0; songIndex < songs.count; songIndex++ {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "songEnded:", name: AVPlayerItemDidPlayToEndTimeNotification, object: songs[songIndex])
        }
    }
    
    func playMusic() {
        
        // ----- This was replaced by the AudioQueuePlayer -----
        // More efficient to do this before getting the audioPlayer to play the song
//        self.audioPlayer.prepareToPlay()
        
        // Play the song
//        self.audioPlayer.play()
        
        if self.audioQueuePlayer.rate > 0 && self.audioQueuePlayer.error == nil {
            // When the audioQueuePlayer is paused, the rate is set to zero. So make sure that the audioQueuePlayer is not paused AND there is no error
            self.audioQueuePlayer.pause()
        } else if currentSongIndex == nil {
            // We haven't started to play yet so set the currentSongIndex to zero
            self.audioQueuePlayer.play()
            self.currentSongIndex = 0
        } else {
            // We already have a currentSongIndex, so don't set that
            self.audioQueuePlayer.play()
        }
    }
    
    func createSongs() -> [AnyObject] {
        
        // Specify all of our song paths
        let firstSongPath = NSBundle.mainBundle().pathForResource("Open Source - Sending My Signal", ofType: "wav")
        let secondSongPath = NSBundle.mainBundle().pathForResource("Timothy Pinkham - The Knolls of Doldesh", ofType: "mp3")
        let thirdSongPath = NSBundle.mainBundle().pathForResource("Open Source - Sending My Signal", ofType: "mp3")

        let firstSongURL = NSURL.fileURLWithPath(firstSongPath!)
        let secondSongURL = NSURL.fileURLWithPath(secondSongPath!)
        let thirdSongURL = NSURL.fileURLWithPath(thirdSongPath!)
        
        // Create some AVPlayerItems and put them in an array
        let firstPlayerItem = AVPlayerItem(URL: firstSongURL)
        let secondPlayerItem = AVPlayerItem(URL: secondSongURL)
        let thirdPlayerItem = AVPlayerItem(URL: thirdSongURL)
        
        let songs: [AnyObject] = [firstPlayerItem, secondPlayerItem, thirdPlayerItem]
        
        return songs
    }
    
    // MARK: Audio Notification
    
    func songEnded(notification: NSNotification) {
        self.currentSongIndex = self.currentSongIndex + 1
        self.updateUI()
    }
    
    // MARK: UIUpdate Helpers
    
    func updateUI() {
        self.currentSongLabel.text = self.currentSongName()
        
        if self.audioQueuePlayer.rate > 0 && self.audioQueuePlayer.error == nil {
            self.playButton.setTitle("Pause", forState: UIControlState.Normal)
        } else {
            self.playButton.setTitle("Play", forState: UIControlState.Normal)
        }
    }
    
    func currentSongName() -> String {
        var currentSong: String
        
        if self.currentSongIndex == 0 {
            currentSong = "Classical Solitude"
        } else if currentSongIndex == 1 {
            currentSong = "The Knolls of Doldesh"
        } else if currentSongIndex == 2 {
            currentSong = "Sending my Signal"
        } else {
            currentSong = "No song playing"
            println("Something went wrong")
        }
        
        return currentSong
    }
}















