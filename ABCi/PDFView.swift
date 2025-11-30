//
//  PDFView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/21.
//
import SwiftUI
import PDFKit

#if os(macOS)
import AppKit
// 修正: 名前を 'PDFViewRepresentable' に変更して、YouTubeViewとの衝突を回避
typealias PDFViewRepresentable = NSViewRepresentable
#else
import UIKit
typealias PDFViewRepresentable = UIViewRepresentable
#endif

// 修正: 継承元も 'PDFViewRepresentable' に変更
struct PDFKitView: PDFViewRepresentable {
    // 表示したいPDFのファイル名（拡張子なし）
    let fileName: String
    
    // ---------------------------------------------------------
    // 共通のPDFView作成ロジック
    // ---------------------------------------------------------
    func makePDFView() -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true // 画面に合わせて自動ズーム
        
        // PDFファイルをバンドルから読み込む
        if let url = Bundle.main.url(forResource: fileName, withExtension: "pdf") {
            if let document = PDFDocument(url: url) {
                pdfView.document = document
            }
        } else {
            print("エラー: \(fileName).pdf が見つかりません")
        }
        
        return pdfView
    }

    // ---------------------------------------------------------
    // macOS (NSViewRepresentable) 用の実装
    // ---------------------------------------------------------
    #if os(macOS)
    // プロトコルの要件に合わせて型を指定
    func makeNSView(context: Context) -> PDFView {
        return makePDFView()
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {
        // 更新が必要な場合はここに記述
    }
    #endif

    // ---------------------------------------------------------
    // iOS / iPadOS (UIViewRepresentable) 用の実装
    // ---------------------------------------------------------
    #if os(iOS)
    func makeUIView(context: Context) -> PDFView {
        return makePDFView()
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // 更新が必要な場合はここに記述
    }
    #endif
}

#Preview {
    // プレビュー用
    PDFKitView(fileName: "report")
        .frame(height: 500)
}
