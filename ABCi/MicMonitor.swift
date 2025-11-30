//
//  MicMonitor.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/20.
//
import Foundation
import AVFoundation
import Combine

class MicMonitor: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    // 音量レベル (0.0 〜 1.0) を公開
    @Published var soundLevel: Float = 0.0
    
    init() {
        setupAudioRecorder()
    }
    
    private func setupAudioRecorder() {
        // マイクの許可を求める
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                print("Mic access granted")
            }
        }
        
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: false)
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch {
            print("Recorder setup failed: \(error.localizedDescription)")
        }
    }
    
    func startMonitoring() {
        audioRecorder?.record()
        // 0.05秒ごとに音量をチェック
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            self.audioRecorder?.updateMeters()
            // デシベル(-160〜0)を 0.0〜1.0 に変換
            let power = self.audioRecorder?.averagePower(forChannel: 0) ?? -160
            self.soundLevel = self.normalizeSoundLevel(level: power)
        }
    }
    
    func stopMonitoring() {
        audioRecorder?.stop()
        timer?.invalidate()
        soundLevel = 0.0
    }
    
    private func normalizeSoundLevel(level: Float) -> Float {
        // -60dB以下は0、0dBに近いほど1
        let level = max(level, -60)
        return pow(10, level / 20) // 指数的に変換して感度を良くする
    }
}
