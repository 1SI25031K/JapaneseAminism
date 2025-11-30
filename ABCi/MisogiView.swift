//
//  MisogiView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/20.
//
import SwiftUI
import AVFoundation

struct MisogiView: View {
    // ドラッグした軌跡の点
    @State private var points: [CGPoint] = []
    
    // 完了判定
    @State private var isCleaned: Bool = false
    
    // 音声マネージャー (効果音用)
    // ※ 必要に応じて wood_creak などを流用するか、新しい水音を追加してください
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 1. 背景層（穢れ/ノイズの状態）
                // 白黒にして、ぼかしを入れ、ノイズを乗せる
                ZStack {
                    Image("misogi_bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .saturation(0) // 白黒
                        .blur(radius: 20) // ぼかし
                        .clipped()
                    
                    // ノイズ風のオーバーレイ
                    Color.black.opacity(0.3)
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .white.opacity(0.1), .clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blendMode(.overlay)
                }
                
                // 2. 前景層（清められた状態）
                // マスクを使って、こすった部分だけを表示する
                Image("misogi_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .mask(
                        Canvas { context, size in
                            // パスを描画してマスクにする
                            var path = Path()
                            path.addLines(points)
                            
                            context.stroke(
                                path,
                                with: .color(.white),
                                style: StrokeStyle(lineWidth: 100, lineCap: .round, lineJoin: .round)
                            )
                        }
                        // マスクの境界を少しぼかして、霧が晴れるような表現に
                        .blur(radius: 10)
                    )
                
                // 3. ガイドと完了メッセージ
                VStack {
                    if !isCleaned {
                        Text("Misogi: Scrub to Purify Signal")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .padding(.top, 50)
                            .opacity(points.isEmpty ? 1 : 0.5)
                    } else {
                        VStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundColor(.yellow)
                            Text("Purification Complete")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            Text("Signal Noise Removed")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(20)
                        .transition(.scale.combined(with: .opacity))
                    }
                    Spacer()
                }
            }
            // ドラッグ操作の検知
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        // 完了していたら何もしない
                        guard !isCleaned else { return }
                        
                        // ポイントを追加
                        let newPoint = value.location
                        points.append(newPoint)
                        
                        // 簡易的な完了判定 (点の数で判定)
                        // 画面サイズにもよりますが、500点くらいで「十分こすった」とみなす
                        if points.count > 500 { // 閾値は調整してください
                            withAnimation(.spring()) {
                                isCleaned = true
                            }
                            // 完了時の振動
                            #if os(macOS)
                            NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
                            #endif
                        }
                    }
            )
            // リセットボタン（デモ用）
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    points.removeAll()
                    withAnimation { isCleaned = false }
                }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
                .buttonStyle(.plain)
                .padding(30)
            }
        }
        .background(Color.black) // 全体背景
        .ignoresSafeArea()
    }
}

#Preview {
    MisogiView()
}
