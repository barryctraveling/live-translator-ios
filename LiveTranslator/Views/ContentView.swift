//
//  ContentView.swift
//  LiveTranslator
//
//  面對面會議即時翻譯介面
//  上方：英文持續累積
//  下方：中文即時翻譯
//

import SwiftUI
import Translation

struct ContentView: View {
    @StateObject private var speechManager = SpeechRecognitionManager()
    @StateObject private var translationManager = TranslationManager()
    
    @State private var translationSession: TranslationSession?
    @State private var showLanguageNotSupported = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 上半部：英文原文（持續累積）
                VStack(alignment: .leading, spacing: 8) {
                    // 標題列
                    HStack {
                        Image(systemName: "waveform")
                            .font(.title3)
                            .foregroundColor(.green)
                        Text("English")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                        Spacer()
                        if speechManager.isRecording {
                            RecordingIndicator()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    // 英文文字區
                    ScrollViewReader { proxy in
                        ScrollView {
                            Text(speechManager.recognizedText.isEmpty ? 
                                 "Waiting for speech..." : 
                                 speechManager.recognizedText)
                                .font(.system(size: 22, weight: .regular))
                                .foregroundColor(speechManager.recognizedText.isEmpty ? 
                                               Color.gray.opacity(0.6) : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 12)
                                .id("englishBottom")
                        }
                        .onChange(of: speechManager.recognizedText) { _, _ in
                            withAnimation(.easeOut(duration: 0.2)) {
                                proxy.scrollTo("englishBottom", anchor: .bottom)
                            }
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.38)
                .background(Color.green.opacity(0.08))
                
                // 分隔線
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                // 下半部：中文翻譯
                VStack(alignment: .leading, spacing: 8) {
                    // 標題列
                    HStack {
                        Image(systemName: "character.book.closed.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                        Text("繁體中文")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        Spacer()
                        if translationManager.isTranslating {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    // 中文文字區
                    ScrollViewReader { proxy in
                        ScrollView {
                            Text(translationManager.translatedText.isEmpty ? 
                                 "翻譯將顯示在這裡..." : 
                                 translationManager.translatedText)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(translationManager.translatedText.isEmpty ? 
                                               Color.gray.opacity(0.6) : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 12)
                                .id("chineseBottom")
                        }
                        .onChange(of: translationManager.translatedText) { _, _ in
                            withAnimation(.easeOut(duration: 0.2)) {
                                proxy.scrollTo("chineseBottom", anchor: .bottom)
                            }
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.38)
                .background(Color.blue.opacity(0.08))
                
                // 控制按鈕區
                VStack(spacing: 12) {
                    // 主按鈕
                    Button(action: toggleRecording) {
                        HStack(spacing: 12) {
                            Image(systemName: speechManager.isRecording ? "stop.fill" : "mic.fill")
                                .font(.title2)
                            Text(speechManager.isRecording ? "停止" : "開始翻譯")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(speechManager.isRecording ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    
                    // 清除按鈕
                    Button(action: clearAll) {
                        HStack(spacing: 8) {
                            Image(systemName: "trash")
                            Text("清除全部")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
            }
        }
        .translationTask(source: .init(identifier: "en"), 
                         target: .init(identifier: "zh-Hant")) { session in
            self.translationSession = session
        }
        .onChange(of: speechManager.recognizedText) { _, newValue in
            // 當辨識文字變化時，請求翻譯（帶防抖動）
            if let session = translationSession, !newValue.isEmpty {
                translationManager.requestTranslation(text: newValue, using: session)
            }
        }
        .alert("錯誤", isPresented: .constant(speechManager.errorMessage != nil)) {
            Button("確定") {
                speechManager.errorMessage = nil
            }
        } message: {
            Text(speechManager.errorMessage ?? "")
        }
        .alert("語言不支援", isPresented: $showLanguageNotSupported) {
            Button("確定", role: .cancel) {}
        } message: {
            Text("請先到「設定 > 一般 > 語言與地區」下載英文和繁體中文語言包")
        }
        .onAppear {
            speechManager.requestPermissions()
        }
    }
    
    private func toggleRecording() {
        if speechManager.isRecording {
            speechManager.stopRecording()
            // 停止時立即翻譯最終結果
            if let session = translationSession, !speechManager.recognizedText.isEmpty {
                Task {
                    await translationManager.translateNow(
                        text: speechManager.recognizedText, 
                        using: session
                    )
                }
            }
        } else {
            speechManager.startRecording()
        }
    }
    
    private func clearAll() {
        speechManager.clearText()
        translationManager.clearText()
    }
}

// 錄音指示器動畫
struct RecordingIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color.red)
                .frame(width: 10, height: 10)
                .opacity(isAnimating ? 1.0 : 0.3)
            Text("REC")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.red)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    ContentView()
}
