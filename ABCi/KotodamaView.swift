//
//  KotodamaView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/20.
//
import SwiftUI

struct KotodamaView: View {
    @StateObject private var mic = MicMonitor()
    
    // アニメーション用の状態
    @State private var rotation: Double = 0.0
    @State private var isActivated: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景
                Color("AppBackground").ignoresSafeArea()
                
                VStack {
                    Text("Kotodama: The Power of Words")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                    
                    Text(isActivated ? "Activation Complete" : "Speak or Clap to infuse energy")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                // --- 魔法陣ビジュアライザー ---
                ZStack {
                    // 1. 外側のリング (回転)
                    Circle()
                        .strokeBorder(
                            AngularGradient(gradient: Gradient(colors: [.blue, .purple, .blue]), center: .center),
                            style: StrokeStyle(lineWidth: 5, dash: [10, 5])
                        )
                        .frame(width: 300, height: 300)
                        .rotationEffect(.degrees(rotation))
                    
                    // 2. 内側の幾何学模様 (音量でスケール変化)
                    ForEach(0..<3) { i in
                        PolygonShape(sides: 6)
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(Double(i) * 30 + rotation * -1))
                            .scaleEffect(1.0 + (CGFloat(mic.soundLevel) * 0.5)) // 音量で拡大
                    }
                    
                    // 3. コア (音量で色と光が変化)
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    isActivated ? .white : .blue,
                                    isActivated ? .yellow : .purple,
                                    .clear
                                ]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 100
                            )
                        )
                        .frame(width: 100 + (CGFloat(mic.soundLevel) * 200), height: 100 + (CGFloat(mic.soundLevel) * 200))
                        .blur(radius: 20)
                        .opacity(0.8)
                        .animation(.easeOut(duration: 0.1), value: mic.soundLevel)
                    
                    // テキスト（レベル表示）
                    if !isActivated {
                        Text(String(format: "Energy: %.0f%%", mic.soundLevel * 100))
                            .font(.caption)
                            .monospacedDigit()
                            .offset(y: 180)
                    }
                }
                // 常時回転アニメーション
                .onAppear {
                    withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                    mic.startMonitoring()
                }
                .onDisappear {
                    mic.stopMonitoring()
                }
                // 音量の監視と発動判定
                .onChange(of: mic.soundLevel) { newValue in
                    if newValue > 0.8 && !isActivated { // 80%を超えたら発動
                        withAnimation(.spring()) {
                            isActivated = true
                        }
                        // 完了時のフィードバック
                        #if os(macOS)
                        NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
                        #endif
                    }
                }
                
                // リセットボタン
                if isActivated {
                    Button(action: {
                        withAnimation { isActivated = false }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 50)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
    }
}

// 六角形などの多角形を描画する構造体
struct PolygonShape: Shape {
    var sides: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let angle = (2.0 * .pi) / Double(sides)
        
        for i in 0..<sides {
            let x = center.x + radius * cos(Double(i) * angle)
            let y = center.y + radius * sin(Double(i) * angle)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

#Preview {
    KotodamaView()
}
