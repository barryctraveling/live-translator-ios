//
//  TranslationManager.swift
//  LiveTranslator
//
//  使用 Apple Translation Framework 進行即時翻譯（英文 → 繁體中文）
//

import Foundation
import Translation

@MainActor
class TranslationManager: ObservableObject {
    @Published var translatedText: String = ""
    @Published var isTranslating: Bool = false
    @Published var errorMessage: String?
    
    private var lastTranslatedSource: String = ""
    private var translationTask: Task<Void, Never>?
    private var pendingText: String = ""
    
    /// 請求翻譯（帶有防抖動機制）
    func requestTranslation(text: String, using session: TranslationSession) {
        // 取消之前的延遲任務
        translationTask?.cancel()
        pendingText = text
        
        // 如果文字沒變化，不翻譯
        guard !text.isEmpty, text != lastTranslatedSource else {
            return
        }
        
        // 延遲 0.5 秒後翻譯（防止打字過程中頻繁翻譯）
        translationTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 秒
            
            guard !Task.isCancelled else { return }
            
            // 確認文字沒有繼續變化
            guard pendingText == text else { return }
            
            await translate(text: text, using: session)
        }
    }
    
    /// 執行翻譯
    private func translate(text: String, using session: TranslationSession) async {
        guard !text.isEmpty, text != lastTranslatedSource else {
            return
        }
        
        isTranslating = true
        
        do {
            let response = try await session.translate(text)
            translatedText = response.targetText
            lastTranslatedSource = text
        } catch {
            print("翻譯錯誤: \(error.localizedDescription)")
            // 保持最後成功的翻譯，不顯示錯誤
        }
        
        isTranslating = false
    }
    
    /// 強制立即翻譯（用於停止錄音時）
    func translateNow(text: String, using session: TranslationSession) async {
        translationTask?.cancel()
        await translate(text: text, using: session)
    }
    
    func clearText() {
        translationTask?.cancel()
        translatedText = ""
        lastTranslatedSource = ""
        pendingText = ""
    }
}
