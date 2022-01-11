//
//  PlayView.swift
//  Echo Keys
//
//  Created by Ali Momeni on 1/7/22.
//

import SwiftUI

struct PlayView: View {
    
    
    @ObservedObject var soundPlayer = SoundPlayer()
    
    var body: some View {
        Text("Echo")
            .onTapGesture {
                let randomSound = self.soundPlayer.sounds.randomElement()
                self.soundPlayer.playSound(soundName: randomSound!)
            }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}
