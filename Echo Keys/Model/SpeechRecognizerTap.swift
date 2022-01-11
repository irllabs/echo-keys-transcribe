//
//  SpeechRecognizerTap.swift
//  Echo Keys
//
//  Created by Ali Momeni on 1/10/22.
//

import Foundation
import SwiftUI
import AudioKit
import AudioKitEX
import AVFoundation
import Speech
import AudioKitUI

class SpeechRecognizerTap: BaseTap, ObservableObject {
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var analyzer: SFSpeechRecognizer?
    var recognitionTask: SFSpeechRecognitionTask?
    
    @Published var transcription = "....."
    
    func setupRecognition() {
        transcription = "........"
        analyzer = SFSpeechRecognizer()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create recognition request") }
        recognitionRequest.shouldReportPartialResults = true
        if let analyzer = analyzer {
            recognitionTask = analyzer.recognitionTask(with: recognitionRequest) { result, err in
                var isFinal = false
                if let result = result {
                    isFinal = result.isFinal
                    print(result.bestTranscription.formattedString)
                    self.transcription = result.bestTranscription.formattedString
                }
                
                if err != nil || isFinal {
                    print("Something went wrong")
                }
            }
        }
    }
    override func doHandleTapBlock(buffer: AVAudioPCMBuffer, at time: AVAudioTime) {
        //print(buffer.floatChannelData!.pointee.pointee.debugDescription)
        if let recognitionRequest = recognitionRequest {
            recognitionRequest.append(buffer)
        }
    }
}
