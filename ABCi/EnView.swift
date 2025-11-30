//
//  EnView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/21.
//
import SwiftUI
import AVFoundation

// ノード（点）のデータモデル
struct Node: Identifiable, Equatable {
    let id = UUID()
    var position: CGPoint
    var isConnected: Bool = false
}

// 接続（線）のデータモデル
struct Connection: Identifiable, Hashable {
    let id = UUID()
    let startID: UUID
    let endID: UUID
    
    // Setに入れて重複を防ぐためのハッシュ関数
    func hash(into hasher: inout Hasher) {
        // 順序関係なく同じ接続とみなすためのロジック
        let sortedIDs = [startID.uuidString, endID.uuidString].sorted()
        hasher.combine(sortedIDs[0])
        hasher.combine(sortedIDs[1])
    }
    
    static func == (lhs: Connection, rhs: Connection) -> Bool {
        let lhsSorted = [lhs.startID.uuidString, lhs.endID.uuidString].sorted()
        let rhsSorted = [rhs.startID.uuidString, rhs.endID.uuidString].sorted()
        return lhsSorted == rhsSorted
    }
}

struct EnView: View {
    // ノードの配列
    @State private var nodes: [Node] = []
    
    // 確定した接続のリスト
    @State private var connections: Set<Connection> = []
    
    // ドラッグ中の操作状態
    @State private var draggingStartID: UUID?
    @State private var currentDragLocation: CGPoint?
    
    // アニメーション用（信号パルス）
    @State private var pulsePhase: Double = 0.0
    @State private var isCompleted: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景
                Color("AppBackground").ignoresSafeArea()
                
                // タイトル
                VStack {
                    Text("En: Forging Connections")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                    
                    Text(isCompleted ? "Neural Network Established" : "Connect all nodes to form a circuit")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                // --- ネットワーク描画エリア ---
                ZStack {
                    // 1. 確定した接続線 (完成後はパルスが走る)
                    Canvas { context, size in
                        for connection in connections {
                            if let startNode = nodes.first(where: { $0.id == connection.startID }),
                               let endNode = nodes.first(where: { $0.id == connection.endID }) {
                                
                                var path = Path()
                                path.move(to: startNode.position)
                                path.addLine(to: endNode.position)
                                
                                // ベースの線
                                context.stroke(
                                    path,
                                    with: .color(isCompleted ? .blue.opacity(0.5) : .white.opacity(0.3)),
                                    lineWidth: 2
                                )
                                
                                // 完了時のパルスアニメーション
                                if isCompleted {
                                    let dashPhase = pulsePhase * 100 // アニメーション値で位相をずらす
                                    context.stroke(
                                        path,
                                        with: .color(.white),
                                        style: StrokeStyle(
                                            lineWidth: 3,
                                            lineCap: .round,
                                            dash: [10, 20], // 点線にして動かす
                                            dashPhase: dashPhase
                                        )
                                    )
                                }
                            }
                        }
                        
                        // 2. ドラッグ中の仮の線
                        if let startID = draggingStartID,
                           let startNode = nodes.first(where: { $0.id == startID }),
                           let currentLocation = currentDragLocation {
                            
                            var path = Path()
                            path.move(to: startNode.position)
                            path.addLine(to: currentLocation)
                            
                            context.stroke(
                                path,
                                with: .color(.yellow),
                                style: StrokeStyle(lineWidth: 2, dash: [5, 5])
                            )
                        }
                    }
                    
                    // 3. ノード（点）の描画
                    ForEach(nodes) { node in
                        Circle()
                            .fill(isNodeConnected(node) ? Color.blue : Color.white.opacity(0.5))
                            .frame(width: 20, height: 20)
                            .shadow(color: isNodeConnected(node) ? .blue : .clear, radius: 10)
                            .position(node.position)
                            // ドラッグ操作
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        // ドラッグ開始
                                        if draggingStartID == nil {
                                            draggingStartID = node.id
                                            // 触覚フィードバック
                                            #if os(macOS)
                                            NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
                                            #endif
                                        }
                                        currentDragLocation = value.location
                                    }
                                    .onEnded { value in
                                        // ドロップ時の判定
                                        if let startID = draggingStartID,
                                           let targetNode = findNode(at: value.location),
                                           targetNode.id != startID {
                                            
                                            // 接続を追加
                                            let newConnection = Connection(startID: startID, endID: targetNode.id)
                                            connections.insert(newConnection)
                                            
                                            // 成功音
                                            // (以前作った AudioPlayer.shared.play(fileName: "paper_snap") 等を流用可)
                                            
                                            checkCompletion()
                                        }
                                        // リセット
                                        draggingStartID = nil
                                        currentDragLocation = nil
                                    }
                            )
                            // ホバー効果で拡大（macOS向け）
                            .scaleEffect(draggingStartID == node.id ? 1.5 : 1.0)
                            .animation(.spring(), value: draggingStartID)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .contentShape(Rectangle()) // 全体でヒットテスト可能に
                
                // 完了エフェクト（中央にロゴなど）
                if isCompleted {
                    Image(systemName: "network")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                        .shadow(color: .blue, radius: 20)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(10)
                }
                
                // リセットボタン
                if isCompleted {
                    Button(action: resetNetwork) {
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
            .onAppear {
                setupNodes(in: geometry.size)
            }
        }
    }
    
    // --- ヘルパー関数 ---
    
    // ノードの初期配置
    private func setupNodes(in size: CGSize) {
        guard nodes.isEmpty else { return }
        // ランダムに5〜7個配置
        for _ in 0..<6 {
            let x = CGFloat.random(in: 50...(size.width - 50))
            let y = CGFloat.random(in: 150...(size.height - 150))
            nodes.append(Node(position: CGPoint(x: x, y: y)))
        }
    }
    
    // 指定位置に近いノードを探す（ドロップ判定）
    private func findNode(at location: CGPoint) -> Node? {
        for node in nodes {
            let distance = hypot(node.position.x - location.x, node.position.y - location.y)
            if distance < 40 { // 判定範囲（半径40px）
                return node
            }
        }
        return nil
    }
    
    // ノードが少なくとも1つの線で繋がっているか
    private func isNodeConnected(_ node: Node) -> Bool {
        connections.contains { $0.startID == node.id || $0.endID == node.id }
    }
    
    // 全てのノードが繋がったか簡易判定（最低ノード数-1本の線が必要）
    private func checkCompletion() {
        // 厳密なグラフ連結判定は複雑なので、簡易的に「全てのノードが何かしら繋がっている」で判定
        let connectedNodeCount = nodes.filter { isNodeConnected($0) }.count
        if connectedNodeCount == nodes.count {
            withAnimation {
                isCompleted = true
            }
            // パルスアニメーション開始
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                pulsePhase = 1.0
            }
            // 完了フィードバック
            #if os(macOS)
            NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .default)
            #endif
        }
    }
    
    private func resetNetwork() {
        withAnimation {
            connections.removeAll()
            isCompleted = false
            pulsePhase = 0.0
        }
    }
}

#Preview {
    EnView()
}
