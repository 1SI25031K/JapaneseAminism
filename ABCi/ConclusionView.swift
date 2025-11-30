//
//  ConclusionView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/18.
//
import SwiftUI
import Combine // Timer

struct ConclusionView: View {
    // MARK: - Slideshow Settings
    // スライドショーで表示する画像名のアセット名配列
    // 【重要】Assets.xcassets にこれらの名前で画像を登録してください
    private let galleryImages: [String] = [
        "gallery_1",
        "gallery_2",
        "gallery_3",
        "gallery_4",
        "gallery_5",
        "gallery_6",
        "gallery_7",
        "gallery_8",
        "gallery_9",
        "gallery_10",
        "gallery_11",
        "gallery_12",
        "gallery_13",
        "gallery_14",
    ]
    
    // 現在表示している画像のインデックス
    @State private var currentIndex: Int = 0
    
    // 3秒ごとに発火するタイマーを作成
    private let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()

    // MARK: - Data Models & Credits
    let credits: [ToolCredit] = [
        ToolCredit(role: "Application Development", tool: "Swift & SwiftUI"),
        ToolCredit(role: "IDE & Build Environment", tool: "Xcode 16+"),
        ToolCredit(role: "Image Generation", tool: "Nano Banana Pro"),
        ToolCredit(role: "Coding Assistance", tool: "Gemini 3 Pro")
    ]
    
    let references: [Reference] = [
        Reference(author: "Spicer, J. V.", year: "2023", title: "Magical Objects Series - Part Seven: Japanese Mythology", source: "Joy V Spicer"),
        Reference(author: "The Metropolitan Museum of Art", year: "n.d.", title: "Shinto", source: "Metropolitan Museum of Art Essays"),
        Reference(author: "Nanzan Institute for Religion and Culture", year: "n.d.", title: "Uncovering Shikigami: The Search for the Spirit Servant of Onmyōdō", source: "Nanzan Institute"),
        Reference(author: "Nanzan Institute for Religion and Culture", year: "n.d.", title: "Animating Objects", source: "Nanzan Institute"),
        Reference(author: "Japan Up Close", year: "2023", title: "Mottainai: A Japanese Philosophy of Waste", source: "Japan Up Close"),
        Reference(author: "Engelsberg Ideas", year: "n.d.", title: "Japan's time of spirits", source: "Engelsberg Ideas"),
        Reference(author: "Milwaukee Independent", year: "n.d.", title: "Waste not, want not: Lessons from the Japanese philosophy of not throwing everything away", source: "Milwaukee Independent"),
        Reference(author: "Wikipedia", year: "n.d.", title: "Shinto / Kami / Onmyōdō / Yōkai / Tsukumogami", source: "Wikimedia Foundation"),
        Reference(author: "Yokai.com", year: "n.d.", title: "Shikigami / Abe no Seimei", source: "Yokai.com"),
        Reference(author: "Uncanny Japan Podcast", year: "n.d.", title: "Ep. 44: Haunted Artifacts (Tsukumogami)", source: "Uncanny Japan"),
        Reference(author: "Ancient Origins", year: "n.d.", title: "The Oriental Magical Practice of Onmyōdō and Its Checkered History", source: "Ancient Origins"),
        Reference(author: "Mimusubi", year: "2020", title: "Yorishiro", source: "Mimusubi.com")
    ]

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                // 1. タイトル
                Text("conclusion.title")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                // 読み上げボタン
                SpeechButton(textKeys: ["conclusion.p1", "conclusion.p2", "conclusion.p3"])

                // 2. 画像スライドショー (静止画から変更)
                // 画像が存在する場合のみ表示
                if !galleryImages.isEmpty {
                    Image(galleryImages[currentIndex])
                        .resizable()
                        .scaledToFit()
                        // 画像が切り替わるたびにユニークなIDを付与してトランジションを発動させる
                        .id(currentIndex)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        // フェードイン・アウトのトランジション設定
                        .transition(.opacity.animation(.easeInOut(duration: 1.0)))
                        // タイマーのイベントを受け取る
                        .onReceive(timer) { _ in
                            // アニメーション付きで次のインデックスへ
                            withAnimation {
                                // 最後の画像の次は0に戻るループ計算
                                currentIndex = (currentIndex + 1) % galleryImages.count
                            }
                        }
                } else {
                    // 画像配列が空の場合のプレースホルダー
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(Text("No gallery images found").foregroundColor(.gray))
                }

                // 3. 結論のテキスト
                VStack(alignment: .leading, spacing: 16) {
                    Text("conclusion.p1")
                    Text("conclusion.p2")
                    Text("conclusion.p3")
                }
                .font(.body)
                .lineSpacing(6)
                
                // 4. 最後のメッセージ
                Text("Will we choose domination, or will we choose coexistence?")
                    .font(.headline)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
                    .opacity(0.8)
                
                Divider()
                    .background(Color.gray)
                
                // --- 5. クレジットセクション ---
                VStack(alignment: .leading, spacing: 15) {
                    Text("Development Credits")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(credits) { credit in
                        HStack(alignment: .firstTextBaseline) {
                            Text(credit.role)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(width: 140, alignment: .leading)
                            
                            Text(credit.tool)
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                        Divider().opacity(0.5)
                    }
                }
                
                // --- 6. 参考文献セクション (APA Style) ---
                VStack(alignment: .leading, spacing: 15) {
                    Text("References")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("APA Citation Style")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                    
                    ForEach(references) { ref in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(ref.author) (\(ref.year)).")
                                .fontWeight(.semibold)
                            
                            Text(ref.title)
                                .italic()
                            
                            Text(ref.source)
                                .foregroundColor(.gray)
                        }
                        .font(.caption)
                        .padding(.bottom, 8)
                    }
                }
                .padding(.top, 10)
                
                // コピーライト
                Text("© 2025 Kosei Miyamoto / Kyushu University")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 30)
            }
            .padding(40)
        }
    }
}

// MARK: - Data Models (前と同じ)
struct ToolCredit: Identifiable {
    let id = UUID()
    let role: String
    let tool: String
}

struct Reference: Identifiable {
    let id = UUID()
    let author: String
    let year: String
    let title: String
    let source: String
}

#Preview {
    ConclusionView()
}
