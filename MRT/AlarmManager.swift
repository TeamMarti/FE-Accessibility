//
//  AlarmManager.swift
//  MRT
//
//  Created by Ronald Sumichael Sunan on 20/07/23.
//

import Foundation
import AVFoundation

class AlarmManager: NSObject, AVAudioPlayerDelegate {
    
    let synthesizer = AVSpeechSynthesizer()
    var alarmRinging: Bool = false
    
    let audioSession: AVAudioSession = {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print(error)
        }
        return audioSession
    }()
    
    lazy var warningUtterance: AVSpeechUtterance! = {
        let utterance = AVSpeechUtterance(string: "ERROR! Your balance is insufficient!")
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-GB_compact")
        return utterance
    }()

    // https://www.youtube.com/watch?v=8-pOCeuXhDM
    lazy var warningSFX: AVAudioPlayer! = {
        do {
            guard let sfx = Bundle.main.url(forResource: "Warning", withExtension: "mp3") else {
                return nil
            }
            let player = try AVAudioPlayer(contentsOf: sfx)
            player.volume = 0.5
            player.delegate = self
            return player
        }
        catch {
            print(error)
            return nil
        }
    }()
    
    func playWarningSound() {
        warningSFX.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        synthesizer.speak(warningUtterance)
    }
}
