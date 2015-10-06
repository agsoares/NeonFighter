//
//  SoundManager.swift
//  MC2
//
//  Created by Adriano Soares on 25/06/15.
//
//

import SpriteKit
import AVFoundation

class SoundManager : NSObject, AVAudioPlayerDelegate {
    static let sharedInstance = SoundManager()
    var player:AVAudioPlayer?
    var loop: Bool!
    var musicVolume:Float = 1.0;
    
    func playMusic (fileNamed: String, looped: Bool = false) {
        var error: NSError?
        let fileURL:NSURL? = NSBundle.mainBundle().URLForResource(fileNamed, withExtension: "mp3")
        if fileURL != nil {
            do {
                // the player must be a field. Otherwise it will be released before playing starts.
                self.player = try AVAudioPlayer(contentsOfURL: fileURL!)
            } catch let error1 as NSError {
                error = error1
                self.player = nil
            }
            if let player = self.player {
                loop = looped
                player.prepareToPlay()
                player.volume = musicVolume
                player.delegate = self
                player.play()
            }
        }
    }
    
    
    func stopMusic() {
        if let player = self.player {
            player.stop()
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if loop == true {
            player.play()
        }
        
    }
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("\(error!.localizedDescription)")
    }
}