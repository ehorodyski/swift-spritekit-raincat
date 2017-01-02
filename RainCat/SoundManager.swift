//
//  SoundManager.swift
//  RainCat
//
//  Created by Eric on 1/2/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {

    // Constants
    // Music: http://www.bensound.com/royalty-free-music
    private let MUSIC_TRACKS = ["bensound-clearday", "bensound-jazzcomedy", "bensound-jazzyfrenchy", "bensound-littleidea"]
    
    // Delcare singleton instance
    static let sharedInstance = SoundManager()
    
    // Private Variables
    private var audioPlayer: AVAudioPlayer?
    private var trackPosition = 0
    
    // Constructor (Override and make private to make singleton)
    private override init() {
        self.trackPosition = Int(arc4random_uniform(UInt32(MUSIC_TRACKS.count)))
    }
    
    // Public Methods
    public func startPlaying() {
        if(self.audioPlayer == nil || self.audioPlayer?.isPlaying == false ) {
            let soundURL = Bundle.main.url(forResource: MUSIC_TRACKS[self.trackPosition], withExtension: "mp3")
            
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
                self.audioPlayer?.delegate = self
            } catch {
                print("Audio player failed to load")
                startPlaying()
            }
            
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
            self.trackPosition = (self.trackPosition + 1) % MUSIC_TRACKS.count
        } else {
            print("Audtio player is already playing")
        }
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        startPlaying()
    }
    
}
