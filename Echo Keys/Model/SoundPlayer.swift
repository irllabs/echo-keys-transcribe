//
//  SoundPlayer.swift
//  Echo Keys
//
//  Created by Ali Momeni on 1/7/22.
//

import Foundation
import AudioKit
import AudioToolbox
import AVFoundation
import SoundpipeAudioKit

class SoundPlayer: ObservableObject {
    // Find audio files in app resources
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    @Published var sounds: [String] = []
    
    // For audio playback
    let engine = AudioEngine()
    let player = AudioPlayer()
    let mixer = Mixer()
    
    func playSound(soundName: String) {
        
        let url = Bundle.main.url(forResource: soundName, withExtension: "wav")
        
        let randomSoundFile = try! AVAudioFile(forReading: url!)
        player.scheduleFile(randomSoundFile, at: nil)
        player.play()
                
    }
    
    init() {
        // Build audio file name list
        Log("Initializing SoundPlayer")
        let fileNameExtension = ".wav"
        if let files = try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath){
            for file in files {
                if file.hasSuffix(fileNameExtension) {
                    let name = file.prefix(file.count - fileNameExtension.count)
                    sounds.append(String(name))
                }
            }
        }
        
        Log(sounds)
        
        // Initialize AudioKit pipeline
        mixer.addInput(player)
        engine.output = mixer

        do {
            try engine.start()
        } catch let err {
            print(err)
        }
    }
}
