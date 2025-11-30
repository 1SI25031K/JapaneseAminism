//
//  ShikigamiView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/17.
//
import SwiftUI
import AVFoundation
import UniformTypeIdentifiers // ドラッグ＆ドロップのデータ型定義に必要

struct ShikigamiView: View {
    
    // 召喚されたかどうか
    @State private var isSummoned: Bool = false
    
    // ドロップエリアにドラッグ中かどうか（ハイライト用）
    @State private var isTargeted: Bool = false
    
    // 音声プレーヤー
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text("shikigami.title")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                SpeechButton(textKeys: ["shikigami.p1", "shikigami.p2", "shikigami.p3"])
                        .padding(.bottom, 10)

                // --- Dynamic Element (Drag & Drop Ritual) ---
                
                VStack(spacing: 30) {
                    
                    // 1. ドロップエリア (召喚の結界)
                    ZStack {
                        // 結界の円
                        Circle()
                            .strokeBorder(
                                isTargeted ? Color.blue : Color.gray.opacity(0.5),
                                style: StrokeStyle(lineWidth: 2, dash: [10])
                            )
                            .background(
                                Circle().fill(isTargeted ? Color.blue.opacity(0.1) : Color.clear)
                            )
                            .frame(height: 280)
                        
                        if isSummoned {
                            // 召喚成功後: マスター/式神の画像が出現
                            Image("shikigami_master")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .padding(10)
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            // 召喚前: ガイドテキスト
                            VStack(spacing: 10) {
                                Image(systemName: "scope") // ターゲットアイコン
                                    .font(.largeTitle)
                                Text("Drop Katashiro Here")
                                    .font(.headline)
                                Text("to Summon Shikigami")
                                    .font(.caption)
                            }
                            .foregroundColor(.gray)
                            .opacity(0.7)
                        }
                    }
                    // ドロップを受け入れる設定
                    .dropDestination(for: String.self) { items, location in
                        // ドロップされた時の処理
                        summonShikigami()
                        return true
                    } isTargeted: { targeted in
                        // ドラッグ中のアイテムが上に来た時の処理
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isTargeted = targeted
                        }
                    }

                    // 2. ドラッグソース (手札の形代)
                    if !isSummoned {
                        VStack {
                            Image("shikigami_doll") // 紙人形の画像
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                // ★ここでドラッグ可能にする
                                .draggable("katashiro_magic") {
                                    // ドラッグ中のプレビュー画像
                                    Image("shikigami_doll")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            
                            HStack {
                                Image(systemName: "hand.draw")
                                Text("Drag this to the circle above")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        // リセットボタン (もう一度試すため)
                        Button(action: {
                            withAnimation {
                                isSummoned = false
                            }
                        }) {
                            Label("Reset Ritual", systemImage: "arrow.counterclockwise")
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 20)
                // -------------------------------------------

                Text("shikigami.p1").font(.body)
                Text("shikigami.p2").font(.body)
                Text("shikigami.p3").font(.body)

                Spacer()
            }
            .padding(40)
        }
    }
    
    private func summonShikigami() {
        // 音を再生
        playSound(fileName: "paper_snap", fileType: "mp3")
        
        // 振動フィードバック (成功時)
        #if os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
        #endif
        
        // アニメーション付きで召喚
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            isSummoned = true
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
    ShikigamiView()
}
