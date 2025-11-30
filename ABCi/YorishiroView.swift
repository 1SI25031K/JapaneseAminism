//
//  YorishiroView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/17.
//
import SwiftUI
import AVFoundation

struct YorishiroView: View {
    
    // 状態管理
    @State private var isCharging: Bool = false   // 長押し中か？
    @State private var isManifested: Bool = false // 神が降りたか？
    @State private var flashOpacity: Double = 0.0 // フラッシュ演出用
    
    // 音声プレーヤー
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text("yorishiro.title")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                SpeechButton(textKeys: ["yorishiro.p1", "yorishiro.p2", "yorishiro.p3"])
                        .padding(.bottom, 10)

                // --- Dynamic Element (Long Press Ritual) ---
                ZStack {
                    // 1. メインの御神木
                    Image("yorishiro_tree")
                        .resizable()
                        .scaledToFit()
                        // 神が降りると黄金に輝く
                        .colorMultiply(isManifested ? Color.yellow : Color.white)
                        .brightness(isManifested ? 0.2 : 0.0)
                        .scaleEffect(isCharging ? 1.02 : 1.0) // 溜めている間少し震える/膨らむ
                        .animation(.easeInOut(duration: 1.0), value: isManifested)
                        .animation(.easeInOut(duration: 0.2), value: isCharging)
                    
                    // 2. 集まってくる光のパーティクル
                    if !isManifested {
                        ForEach(0..<15) { index in
                            LightParticle(isCharging: isCharging, index: index)
                        }
                    }
                    
                    // 3. 神々しさのオーラ（完了時）
                    if isManifested {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [.white.opacity(0.8), .yellow.opacity(0.2), .clear]),
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 200
                                )
                            )
                            .scaleEffect(1.5)
                            .blur(radius: 20)
                            .transition(.opacity)
                    }
                    
                    // 4. ガイドテキスト (長押し中は消す)
                    if !isCharging && !isManifested {
                        VStack {
                            Spacer()
                            HStack {
                                Image(systemName: "touchplus")
                                Text("Press & Hold to Pray")
                            }
                            .font(.headline)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                        }
                        .transition(.opacity)
                    }
                }
                .frame(height: 350)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onLongPressGesture(minimumDuration: 3.0, pressing: { pressing in
                    // 押している間/離した瞬間呼ばれる
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isCharging = pressing
                    }
                    // チャージ開始時に少しフィードバック
                    if pressing && !isManifested {
                        #if os(macOS)
                        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
                        #endif
                        playSound(fileName: "Angel", fileType: "mp3")
                    }
                }, perform: {
                    // 3秒押し切った時に呼ばれる
                    manifestKami()
                })
                // 5. フラッシュエフェクト (画面全体を一瞬白くする)
                .overlay(
                    Color.white
                        .opacity(flashOpacity)
                        .allowsHitTesting(false) // タップを邪魔しない
                )
                
                // -------------------------------------------

                Text("yorishiro.p1").font(.body)
                Text("yorishiro.p2").font(.body)
                Text("yorishiro.p3").font(.body)

                Spacer()
                
                // リセットボタン（デモ用）
                if isManifested {
                    Button("Reset Ritual") {
                        withAnimation {
                            isManifested = false
                        }
                    }
                    .padding(.top)
                }
            }
            .padding(40)
        }
    }
    
    // 神の顕現処理
    private func manifestKami() {
        guard !isManifested else { return }
        
        isManifested = true
        isCharging = false
        
        // 音を再生
        playSound(fileName: "shrine_bell", fileType: "mp3")
        
        // 振動
        #if os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
        #endif
        
        // フラッシュアニメーション
        withAnimation(.easeOut(duration: 0.1)) {
            flashOpacity = 1.0
        }
        // すぐにフェードアウト
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 1.5)) {
                flashOpacity = 0.0
            }
        }
    }
    
    private func playSound(fileName: String, fileType: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: fileType) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("エラー: 音声ファイルを再生できませんでした。")
            }
        }
    }
}

// MARK: - 光のパーティクルビュー
struct LightParticle: View {
    var isCharging: Bool
    var index: Int
    
    // ランダムな開始位置を生成するためのプロパティ
    @State private var startOffset: CGSize = .zero
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: isCharging ? 8 : 4, height: isCharging ? 8 : 4) // 集まるとき少し大きくなる
            .blur(radius: 2)
            .opacity(isCharging ? 0.8 : 0.0) // チャージ中だけ見える
            .offset(isCharging ? .zero : startOffset) // チャージ中は中心(0,0)へ、それ以外は外へ
            .animation(
                isCharging ?
                    .easeIn(duration: 1.5).delay(Double(index) * 0.05) : // 時間差で吸い込まれる
                    .default,
                value: isCharging
            )
            .onAppear {
                // 画面外のランダムな位置を計算
                let angle = Double.random(in: 0...2 * .pi)
                let distance = Double.random(in: 150...250)
                startOffset = CGSize(
                    width: cos(angle) * distance,
                    height: sin(angle) * distance
                )
            }
    }
}

#Preview {
    YorishiroView()
}
