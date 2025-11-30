//
//  SpeechButton.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/20.
//
import SwiftUI

struct SpeechButton: View {
    // 読み上げたいテキストのキー（配列で受け取る）
    let textKeys: [String]
    
    @StateObject private var speechManager = SpeechManager.shared
    
    var body: some View {
        Button(action: {
            if speechManager.isSpeaking {
                // 話している最中なら止める
                speechManager.stop()
            } else {
                // 止まっているなら、キーからテキストを取り出して結合し、読み上げる
                let fullText = textKeys.map { key in
                    String(localized: String.LocalizationValue(key))
                }.joined(separator: " ") // 段落の間をスペースで繋ぐ
                
                speechManager.speak(text: fullText)
            }
        }) {
            HStack {
                Image(systemName: speechManager.isSpeaking ? "stop.circle.fill" : "speaker.wave.2.circle.fill")
                    .font(.title)
                
                Text(speechManager.isSpeaking ? "Stop Reading" : "Read Aloud")
                    .fontWeight(.semibold)
            }
            .padding()
            .background(speechManager.isSpeaking ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
            .foregroundColor(speechManager.isSpeaking ? .red : .blue)
            .cornerRadius(10)
        }
        .buttonStyle(.plain) // macOSでのボタンスタイル調整
    }
}

#Preview {
    // プレビュー用（実際のキーがないと空読みになります）
    SpeechButton(textKeys: ["intro.p1", "intro.p2"])
}
