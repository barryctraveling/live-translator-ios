//
//  HistoryManager.swift
//  LiveTranslator
//
//  記錄並匯出會議翻譯歷史
//

import Foundation

struct TranslationRecord: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let originalText: String
    let translatedText: String
    
    init(original: String, translated: String) {
        self.id = UUID()
        self.timestamp = Date()
        self.originalText = original
        self.translatedText = translated
    }
}

@MainActor
class HistoryManager: ObservableObject {
    @Published var records: [TranslationRecord] = []
    @Published var sessionStartTime: Date?
    
    /// 開始新的會議記錄
    func startSession() {
        sessionStartTime = Date()
        records.removeAll()
    }
    
    /// 結束會議記錄
    func endSession() {
        // 可以在這裡保存到本地儲存
    }
    
    /// 新增翻譯記錄
    func addRecord(original: String, translated: String) {
        let record = TranslationRecord(original: original, translated: translated)
        records.append(record)
    }
    
    /// 清除所有記錄
    func clearRecords() {
        records.removeAll()
        sessionStartTime = nil
    }
    
    /// 匯出為純文字
    func exportAsText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var text = "# 會議翻譯記錄\n"
        
        if let startTime = sessionStartTime {
            text += "開始時間: \(dateFormatter.string(from: startTime))\n"
        }
        text += "匯出時間: \(dateFormatter.string(from: Date()))\n"
        text += "---\n\n"
        
        for record in records {
            let time = dateFormatter.string(from: record.timestamp)
            text += "[\(time)]\n"
            text += "EN: \(record.originalText)\n"
            text += "中: \(record.translatedText)\n\n"
        }
        
        return text
    }
    
    /// 匯出為 CSV
    func exportAsCSV() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var csv = "時間,英文原文,中文翻譯\n"
        
        for record in records {
            let time = dateFormatter.string(from: record.timestamp)
            let original = record.originalText.replacingOccurrences(of: "\"", with: "\"\"")
            let translated = record.translatedText.replacingOccurrences(of: "\"", with: "\"\"")
            csv += "\"\(time)\",\"\(original)\",\"\(translated)\"\n"
        }
        
        return csv
    }
    
    /// 計算會議持續時間
    var sessionDuration: String {
        guard let startTime = sessionStartTime else { return "0:00" }
        let duration = Date().timeIntervalSince(startTime)
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    /// 總字數統計
    var totalWordCount: Int {
        records.reduce(0) { $0 + $1.originalText.split(separator: " ").count }
    }
}
