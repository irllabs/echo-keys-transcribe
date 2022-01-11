//
//  RecorderConductor.swift
//  Echo Vroom
//
//  Created by Ali Momeni on 1/7/22.
//

import Foundation

import AVFoundation
import AudioKit
import AudioKitEX
import AudioToolbox
import SoundpipeAudioKit
import CoreMotion
import SwiftUI
import Speech

// For manging recording state
struct RecorderData {
    var isRecording = false
    var isPlaying = false

}

class RecorderConductor: ObservableObject {
            
    // For audio playback
    let engine = AudioEngine()
    // let mic: AudioEngine.InputNode?
    let player = AudioPlayer()
    let speechMixer = Mixer()
    let recordingMixer = Mixer()
    let mixer = Mixer()
    
    var env: AmplitudeEnvelope
    //var plot: NodeOutputPlot
    
    // For audio recording
    let recorder: NodeRecorder
    var silencer: Fader?
    
    // For speech recognition
    // @Published var speechRecognizerTap: SpeechRecognizerTap
    @Published var speechRecognizerTap : SpeechRecognizerTap

    

    var buffer: AVAudioPCMBuffer

    @Published var data = RecorderData() {
        didSet {
            if data.isRecording {
                NodeRecorder.removeTempFiles()
                do {
                    try recorder.record()
                    speechRecognizerTap.start()
                    speechRecognizerTap.setupRecognition()

                } catch let err {
                    print(err)
                }
            } else {
                recorder.stop()
                speechRecognizerTap.stop()
                //bufferReversed = buffer.reverse()!
            }

            if data.isPlaying {
                if let file = recorder.audioFile {
                    if (recorder.isRecording) {
                        recorder.stop()
                        speechRecognizerTap.stop()
                    }
    
                    player.file = file
                    player.play()
                }
            } else {
                player.stop()
            }
        }
    }
    
    init() {
        // #if os(iOS)
        do {
            try Settings.session.setPreferredSampleRate(44100)
        } catch let err {
            print(err)
        }
        // #endif
        
        // is this necessary?
        do {
            Settings.bufferLength = .short
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                            options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print(err)
        }
    
        
        // define the microphone input
        let input = engine.input

        // a pass-thru mixer to tap for speech recognition
        speechMixer.addInput(input!)
        speechRecognizerTap = SpeechRecognizerTap(speechMixer, bufferSize: 1_024)
//        speechRecognizerTap.setupRecognition()
        
        // an inline mixer to use for input for the NodeRecorder
        recordingMixer.addInput(speechMixer)
        
        // pass the inline recording mixer to the NodeRecorder
        do {
            recorder = try NodeRecorder(node: recordingMixer)
        } catch let err {
            fatalError("\(err)")
        }
        
        // does this prevent mic-input to go to the speaker output?
        let silencer = Fader(recordingMixer, gain: 0)
        self.silencer = silencer
        mixer.addInput(silencer)
        
        // add player mixer to we hear playback
        mixer.addInput(player)
        
        // what does this do?
        env = AmplitudeEnvelope(mixer)

        engine.output = mixer
        
        buffer = Cookbook.loadBuffer(filePath: "echo_baba3.wav")

    }
    
    
    func start() {
        //plot.start()

        do {
            try engine.start()
        } catch let err {
            print(err)
        }
    }

    func stop() {
        engine.stop()
    }
    
    
    
}
