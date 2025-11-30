//
//  YouTubeView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/18.
//
import SwiftUI
import WebKit

#if os(macOS)
import AppKit
// Macの場合は NSViewRepresentable を使うエイリアスを作る
typealias ViewRepresentable = NSViewRepresentable
#else
import UIKit
// iPad/iOSの場合は UIViewRepresentable を使うエイリアスを作る
typealias ViewRepresentable = UIViewRepresentable
#endif

struct YouTubeView: ViewRepresentable {
    let videoID: String
    
    // ---------------------------------------------------------
    // 共通のWebView作成ロジック
    // ---------------------------------------------------------
    func makeWebView() -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        
        // iOSのみの設定（インライン再生許可）
        #if os(iOS)
        webConfiguration.allowsInlineMediaPlayback = true
        #endif
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        // iOSのみの設定（スクロール無効、背景色）
        #if os(iOS)
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .black
        #else
        // macOS用の設定（必要な場合）
        webView.layer?.backgroundColor = NSColor.black.cgColor
        #endif
        
        return webView
    }
    
    func loadVideo(in webView: WKWebView) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // ---------------------------------------------------------
    // macOS (NSViewRepresentable) 用の実装
    // ---------------------------------------------------------
    #if os(macOS)
    func makeNSView(context: Context) -> WKWebView {
        return makeWebView()
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        loadVideo(in: nsView)
    }
    #endif
    // ---------------------------------------------------------
    // iOS / iPadOS (UIViewRepresentable) 用の実装
    // ---------------------------------------------------------
    #if os(iOS)
    func makeUIView(context: Context) -> WKWebView {
        return makeWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        loadVideo(in: uiView)
    }
    #endif
}

#Preview {
    YouTubeView(videoID: "m67-b6Ie7eQ")
        .frame(height: 220)
}
