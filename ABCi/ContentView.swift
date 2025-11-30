//
//  ContentView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/17.
//

import SwiftUI

// 1. ナビゲーション用のページ識別子
enum Page: Hashable {
    case introduction
    // メインコンテンツ
    case tsukumogami
    case shikigami
    case yorishiro
    case misogi
    case neural
    case kotodama
    case en
    case document
    case conclusion
}

struct ContentView: View {
    
    // 2. 現在選択中のページを管理する
    @State private var selectedPage: Page? = .introduction // 起動時はIntroductionを選択

    var body: some View {
        NavigationSplitView {
            // --- サイドバー (Sidebar) ---
            List(selection: $selectedPage) {
                // 3. String Catalogのキーで表示
                Label("intro.title", systemImage: "books.vertical.fill") // Localizable.xcstringsから読み込まれる
                    .tag(Page.introduction)
                
                
                // 4. メインコンテンツをフォルダ（DisclosureGroup）でまとめる
                DisclosureGroup("main_content.title") {
                    
                    Label("tsukumogami.title", systemImage: "rainbow")
                        .tag(Page.tsukumogami)
                    
                    Label("shikigami.title", systemImage: "aqi.medium")
                        .tag(Page.shikigami)

                    Label("yorishiro.title", systemImage: "theatermask.and.paintbrush.fill")
                        .tag(Page.yorishiro)
                    
                    Label("Misogi", systemImage: "drop.fill")
                        .tag(Page.misogi)
                    
                    Label("Kotodama", systemImage: "mic.fill")
                        .tag(Page.kotodama)
                    
                    Label("BCI Simulation", systemImage: "waveform.path.ecg")
                        .tag(Page.neural)
                    
                    Label("En (Networking)", systemImage: "point.3.connected.trianglepath.dotted")
                        .tag(Page.en)
                    
                    
                    
                }

                //NavigationLink(value: Page.misogi) {
                    //Label("Misogi (Denoising)", systemImage: "drop.fill") // 水のアイコン
                //}
                
               
                //NavigationLink(value: Page.kotodama) {
                    //Label("Kotodama (Voice)", systemImage: "mic.fill")
                //}
                //NavigationLink(value: Page.en) {
                    
                //}
                NavigationLink(value: Page.document) {
                    Label("Documents", systemImage: "doc.text.fill")
                }
                
                NavigationLink(value: Page.conclusion) {
                    Label("conclusion.title", systemImage: "book.pages")
                }
            }
            .navigationTitle("Menu")
            .listStyle(.sidebar) // macOS/iPadOSらしいスタイル
            
        } detail: {
            // --- 詳細ビュー (Detail) ---
            // 5. 選択されたページに応じて表示を切り替え
            VStack {
                switch selectedPage {
                case .introduction:
                    IntroductionView()
                case .tsukumogami:
                    TsukumogamiView()
                case .shikigami:
                    ShikigamiView()
                case .yorishiro:
                    YorishiroView()
                case .misogi:
                    MisogiView()
                case .neural:
                    NeuralView()
                case .kotodama:
                    KotodamaView()
                case .en:
                    EnView()
                case .document:
                    DocumentView()
                case .conclusion:
                    ConclusionView()
                case .none:
                    Text("Select a topic from the menu.")
                }
            }
            // 6. 白黒シックなUIの基本設定
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("AppBackground"))
            .foregroundStyle(Color("AppText"))
        }
    }
}

#Preview {
    ContentView()
}
