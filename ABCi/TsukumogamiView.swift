//
//  TsukumogamiView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/17.
//
import SwiftUI
import AVFoundation

struct TsukumogamiView: View {
    
    // 画像の切り替え状態
    @State private var isShowingYokai: Bool = false
    
    // マウスホバーの状態 (New!)
    @State private var isHovering: Bool = false
    
    // 音声プレーヤー
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("tsukumogami.title")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                SpeechButton(textKeys: ["tsukumogami.p1", "tsukumogami.p2", "tsukumogami.p3"])
                        .padding(.bottom, 10)
                // --- Dynamic Element (Hover + Tap + Sound) ---
                ZStack {
                    // 背景の円 (ホバー時に少し光る演出)
                    Circle()
                        .fill(Color.blue.opacity(isHovering ? 0.1 : 0.0))
                        .scaleEffect(isHovering ? 1.1 : 0.8)
                        .animation(.easeInOut(duration: 0.5), value: isHovering)
                    
                    if isShowingYokai {
                        // 妖怪になった後の画像
                        Image("yokai_kasa")
                            .resizable()
                            .scaledToFit()
                            .transition(.scale.combined(with: .opacity)) // ポップに出現
                    } else {
                        // 通常の道具画像
                        Image("tool_kasa")
                            .resizable()
                            .scaledToFit()
                            .transition(.opacity)
                            // --- ホバー時のアニメーション (New!) ---
                            .rotationEffect(.degrees(isHovering ? 2 : -2)) // 左右に揺れる
                            .scaleEffect(isHovering ? 1.05 : 1.0) // 少し大きくなる
                            // ずっと揺れ続けるアニメーション
                            .animation(
                                isHovering ?
                                    .easeInOut(duration: 0.15).repeatForever(autoreverses: true) :
                                    .default,
                                value: isHovering
                            )
                    }
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                // 背景エリア
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                // --- マウスホバーの検知 (New!) ---
                .onHover { hovering in
                    // 妖怪になっていない時だけ反応する
                    if !isShowingYokai {
                        isHovering = hovering
                    }
                }
                // ----------------------------------
                .onTapGesture {
                    // 1. タップ時に音を再生
                    playSound(fileName: "Horror", fileType: "mp3")
                    // 2. 振動(Haptics)を加える (トラックパッド等で感触があれば)
                    #if os(macOS)
                    NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
                    #endif
                    // 3. 画像を切り替え
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                        isShowingYokai.toggle()
                        isHovering = false // 変身したら震えを止める
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    // ガイドの表示もホバー時に強調
                    HStack(spacing: 4) {
                        Image(systemName: "hand.tap")
                        Text(isShowingYokai ? "Tap to Revert" : "Tap to Awaken")
                    }
                    .font(.caption)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .padding(10)
                    .opacity(isHovering || isShowingYokai ? 1.0 : 0.6)
                }

                // テキストコンテンツ
                Text("tsukumogami.p1").font(.body)
                Text("tsukumogami.p2").font(.body)
                
                // 動画プレーヤー
                Text("Video: Hari-kuyō Ceremony")
                    .font(.headline)
                    .padding(.top, 10)
                
                YouTubeView(videoID: "YOUR_VIDEO_ID_HERE")
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                Text("tsukumogami.p3").font(.body)

                Spacer()
            }
            .padding(40)
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

#Preview {
    TsukumogamiView()
}
