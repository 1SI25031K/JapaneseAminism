//
//  SpeechManager.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/20.
//

import SwiftUI
import AVFoundation
import Combine // ← 【重要】これを追加しないとObservableObjectでエラーになります

class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    static let shared = SpeechManager()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    // 現在読み上げ中かどうか
    @Published var isSpeaking: Bool = false
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(text: String) {
        if synthesizer.isSpeaking {
            stop()
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        
        synthesizer.speak(utterance)
        isSpeaking = true
    }
    
    func stop() {
        // 【修正】 stopImmediate() ではなく stopSpeaking(at: .immediate) です
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
    
    // 読み上げ終了時のデリゲート
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // UIの更新はメインスレッドで行う必要があります
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    // キャンセルされた時（stopで止めた時）もフラグを下ろす
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
}
