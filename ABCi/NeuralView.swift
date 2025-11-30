//
//  NeuralView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/19.
//
import SwiftUI

struct NeuralView: View {
    // マウス位置の正規化された値 (0.0 〜 1.0)
    @State private var inputFrequency: Double = 0.5
    @State private var inputAmplitude: Double = 0.5
    
    // シンクロ状態の判定
    @State private var isSynced: Double = 0.0 // 0.0(不一致) -> 1.0(完全一致)
    @State private var showSuccessMessage: Bool = false
    
    // ターゲット（理想）の値
    let targetFreq: Double = 0.7
    let targetAmp: Double = 0.3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景（黒）
                Color("AppBackground").ignoresSafeArea()
                
                VStack {
                    // タイトルとガイド
                    Text("BCI Calibration Mode")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(showSuccessMessage ? "NEURAL LINK ESTABLISHED" : "Sync your mind waves...")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(showSuccessMessage ? .blue : .white)
                        .animation(.easeInOut, value: showSuccessMessage)
                    
                    Spacer()
                }
                .padding(.top, 40)
                
                // --- 波形の描画 ---
                // 修正点: ロジックを関数に外出しして、コンパイラエラーを回避
                TimelineView(.animation) { timeline in
                    Canvas { context, size in
                        drawWaves(context: &context, size: size, date: timeline.date)
                    }
                }
                .frame(height: 400)
                // --- マウス操作による波形の変化 ---
                .onHover { hovering in
                    // ホバー中も計算を続ける
                }
                .onContinuousHover { phase in
                    switch phase {
                    case .active(let location):
                        // マウス位置を 0.0〜1.0 に正規化
                        let normalizedX = location.x / geometry.size.width
                        let normalizedY = location.y / geometry.size.height
                        
                        withAnimation(.linear(duration: 0.1)) {
                            inputFrequency = normalizedX
                            inputAmplitude = normalizedY
                            
                            // シンクロ率の計算 (ターゲットとの近さ)
                            let freqDiff = abs(inputFrequency - targetFreq)
                            let ampDiff = abs(inputAmplitude - targetAmp)
                            
                            // 誤差が小さければシンクロ率が上がる
                            if freqDiff < 0.1 && ampDiff < 0.1 {
                                isSynced = min(isSynced + 0.02, 1.0)
                            } else {
                                isSynced = max(isSynced - 0.05, 0.0)
                            }
                            
                            // 完全シンクロ判定
                            if isSynced >= 0.95 {
                                showSuccessMessage = true
                            }
                        }
                    case .ended:
                        break
                    }
                }
                
                // ガイド円（ターゲットの状態を可視化）
                if !showSuccessMessage {
                    Circle()
                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                        .frame(width: 50, height: 50)
                        .position(
                            x: geometry.size.width * targetFreq,
                            y: geometry.size.height * targetAmp
                        )
                    
                    // 現在のマウス位置カーソル
                    Circle()
                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                        .position(
                            x: geometry.size.width * inputFrequency,
                            y: geometry.size.height * inputAmplitude
                        )
                }
            }
        }
    }
    
    // MARK: - 描画ロジック (関数に切り出し)
    
    // Canvasの中身をここに移動しました
    private func drawWaves(context: inout GraphicsContext, size: CGSize, date: Date) {
        let time = date.timeIntervalSinceReferenceDate
        
        // 1. ユーザーの波（白/赤）
        let userPath = createWavePath(
            in: size,
            frequency: inputFrequency * 20 + 2, // マウスXで変化
            amplitude: inputAmplitude * 100 + 10, // マウスYで変化
            phase: time * 5
        )
        
        // シンクロ率に応じて色を変える（赤→青）
        let waveColor = Color(
            red: 1.0 - isSynced,
            green: isSynced,
            blue: 1.0
        )
        
        context.stroke(
            userPath,
            with: .color(waveColor),
            lineWidth: 3 + (isSynced * 2)
        )
        
        // 2. ターゲットの波（薄いガイドライン）
        if !showSuccessMessage {
            let targetPath = createWavePath(
                in: size,
                frequency: targetFreq * 20 + 2,
                amplitude: targetAmp * 100 + 10,
                phase: time * 5
            )
            context.stroke(
                targetPath,
                with: .color(.gray.opacity(0.3)),
                style: StrokeStyle(lineWidth: 2, dash: [5, 5])
            )
        }
    }
    
    // サイン波のパスを作成する関数
    private func createWavePath(in size: CGSize, frequency: Double, amplitude: Double, phase: Double) -> Path {
        Path { path in
            let midHeight = size.height / 2
            let width = size.width
            
            path.move(to: CGPoint(x: 0, y: midHeight))
            
            for x in stride(from: 0, to: width, by: 2) {
                // サイン波の公式: y = A * sin(B(x + C)) + D
                let relativeX = x / width
                let sine = sin((relativeX * frequency * .pi * 2) + phase)
                let y = midHeight + (sine * amplitude)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
    }
}

#Preview {
    NeuralView()
}
