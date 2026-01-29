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
    @StateObject private var historyManager = HistoryManager()
    
    @State private var translationSession: TranslationSession?
    @State private var showSettings = false
    @State private var showHistory = false
    @State private var showExportSheet = false
    
    @AppStorage("englishFontSize") private var englishFontSize: Double = 22
    @AppStorage("chineseFontSize") private var chineseFontSize: Double = 24
    @AppStorage("autoScroll") private var autoScroll: Bool = true
    @AppStorage("keepScreenOn") private var keepScreenOn: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 頂部工具列
                HStack {
                    // 會議時間
                    if speechManager.isRecording {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                            Text(historyManager.sessionDuration)
                                .font(.caption)
                                .monospacedDigit()
                        }
                        .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    // 設定按鈕
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape")
                            .font(.title3)
                    }
                    
                    // 歷史記錄按鈕
                    Button(action: { showHistory = true }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.title3)
                    }
                    .padding(.leading, 12)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                // 上半部：英文原文（持續累積）
                VStack(alignment: .leading, spacing: 8) {
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
                    .padding(.top, 8)
                    
                    ScrollViewReader { proxy in
                        ScrollView {
                            Text(speechManager.recognizedText.isEmpty ? 
                                 "Waiting for speech..." : 
                                 speechManager.recognizedText)
                                .font(.system(size: englishFontSize))
                                .foregroundColor(speechManager.recognizedText.isEmpty ? 
                                               Color.gray.opacity(0.6) : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 12)
                                .id("englishBottom")
                        }
                        .onChange(of: speechManager.recognizedText) { _, _ in
                            if autoScroll {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    proxy.scrollTo("englishBottom", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.35)
                .background(Color.green.opacity(0.08))
                
                // 分隔線
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                // 下半部：中文翻譯
                VStack(alignment: .leading, spacing: 8) {
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
                    .padding(.top, 8)
                    
                    ScrollViewReader { proxy in
                        ScrollView {
                            Text(translationManager.translatedText.isEmpty ? 
                                 "翻譯將顯示在這裡..." : 
                                 translationManager.translatedText)
                                .font(.system(size: chineseFontSize))
                                .foregroundColor(translationManager.translatedText.isEmpty ? 
                                               Color.gray.opacity(0.6) : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 12)
                                .id("chineseBottom")
                        }
                        .onChange(of: translationManager.translatedText) { _, _ in
                            if autoScroll {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    proxy.scrollTo("chineseBottom", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.35)
                .background(Color.blue.opacity(0.08))
                
                // 控制按鈕區
                VStack(spacing: 10) {
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
                        .padding(.vertical, 14)
                        .background(speechManager.isRecording ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    
                    // 次要按鈕
                    HStack(spacing: 12) {
                        Button(action: clearAll) {
                            HStack(spacing: 6) {
                                Image(systemName: "trash")
                                Text("清除")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray5))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                        }
                        
                        Button(action: { showExportSheet = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "square.and.arrow.up")
                                Text("匯出")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray5))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                        }
                        .disabled(historyManager.records.isEmpty)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
            }
        }
        .translationTask(source: .init(identifier: "en"), 
                         target: .init(identifier: "zh-Hant")) { session in
            self.translationSession = session
        }
        .onChange(of: speechManager.recognizedText) { oldValue, newValue in
            // 當辨識文字變化時，請求翻譯
            if let session = translationSession, !newValue.isEmpty {
                translationManager.requestTranslation(text: newValue, using: session)
            }
        }
        .onChange(of: translationManager.translatedText) { oldValue, newValue in
            // 翻譯完成後，記錄到歷史
            if !newValue.isEmpty && newValue != oldValue {
                historyManager.addRecord(
                    original: speechManager.recognizedText,
                    translated: newValue
                )
            }
        }
        .onAppear {
            speechManager.requestPermissions()
            if keepScreenOn {
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showHistory) {
            HistoryView(historyManager: historyManager)
        }
        .sheet(isPresented: $showExportSheet) {
            ExportSheet(historyManager: historyManager)
        }
        .alert("錯誤", isPresented: .constant(speechManager.errorMessage != nil)) {
            Button("確定") {
                speechManager.errorMessage = nil
            }
        } message: {
            Text(speechManager.errorMessage ?? "")
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
            historyManager.endSession()
        } else {
            historyManager.startSession()
            speechManager.startRecording()
        }
    }
    
    private func clearAll() {
        speechManager.clearText()
        translationManager.clearText()
    }
}

// 錄音指示器
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

// 歷史記錄頁面
struct HistoryView: View {
    @ObservedObject var historyManager: HistoryManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if historyManager.records.isEmpty {
                    Text("尚無翻譯記錄")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(historyManager.records) { record in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(record.originalText)
                                .font(.subheadline)
                                .foregroundColor(.green)
                            Text(record.translatedText)
                                .font(.body)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("翻譯記錄")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// 匯出選單
struct ExportSheet: View {
    @ObservedObject var historyManager: HistoryManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Button(action: exportAsText) {
                    Label("匯出為文字檔 (.txt)", systemImage: "doc.text")
                }
                
                Button(action: exportAsCSV) {
                    Label("匯出為 CSV", systemImage: "tablecells")
                }
            }
            .navigationTitle("匯出記錄")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func exportAsText() {
        let text = historyManager.exportAsText()
        shareText(text, filename: "meeting_transcript.txt")
    }
    
    private func exportAsCSV() {
        let csv = historyManager.exportAsCSV()
        shareText(csv, filename: "meeting_transcript.csv")
    }
    
    private func shareText(_ text: String, filename: String) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try? text.write(to: tempURL, atomically: true, encoding: .utf8)
        
        let activityVC = UIActivityViewController(
            activityItems: [tempURL],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
        
        dismiss()
    }
}

#Preview {
    ContentView()
}
