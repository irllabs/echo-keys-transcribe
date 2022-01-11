//
//  RecordView.swift
//  Echo Keys
//
//  Created by Ali Momeni on 1/7/22.
//

import SwiftUI
import Speech

struct RecordView: View {
    
    @StateObject var conductor = RecorderConductor()
    // @ObservedObject var speechRecognizerTap : SpeechRecognizerTap
    
    // private let speechRecognizer = SpeechRecognizer()

    
    var body: some View {
        VStack {


            Spacer()
            Text(conductor.data.isRecording ? "STOP RECORDING" : "RECORD")
                .onTapGesture {self.conductor.data.isRecording.toggle()
            }
            Spacer()
            Text(conductor.data.isPlaying ? "STOP" : "PLAY")
                .onTapGesture {self.conductor.data.isPlaying.toggle()
            }
            Spacer()
            Text(self.conductor.speechRecognizerTap.transcription)
            
            
        }

        .padding()
        .navigationBarTitle(Text("Recorder"))
        .onAppear {
            self.conductor.start()

        }
        .onDisappear {
            self.conductor.stop()
        }
    }
}
//
//struct RecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordView()
//    }
//}
