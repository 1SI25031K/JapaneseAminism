//
//  DocumentView.swift
//  ABCi
//
//  Created by Kosei Miyamoto on 2025/11/21.
//
import SwiftUI

struct DocumentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reference Material")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal, 40)
                .padding(.top, 40)
            
            Text("Research Report on Animism in Japan")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)

            // PDF表示エリア
            // ここに、ステップ1で追加したPDFのファイル名（拡張子なし）を指定します
            PDFKitView(fileName: "report")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(40) // 外側に余白を持たせる
                .shadow(radius: 20)
        }
        .background(Color("AppBackground")) // アプリの背景色
    }
}

#Preview {
    DocumentView()
}
