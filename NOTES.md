# iOS Live Translator 開發筆記

## 📅 2026-01-30 凌晨工作記錄

### ✅ 已完成

1. **專案結構建立**
   - LiveTranslator.xcodeproj
   - SwiftUI 介面
   - SpeechRecognitionManager (語音辨識)
   - TranslationManager (翻譯)

2. **核心功能實作**
   - 使用 Apple Speech Framework 進行英文語音辨識
   - 使用 Apple Translation API (iOS 18+) 進行翻譯
   - 介面：上方英文累積、下方中文翻譯
   - 防抖動機制避免頻繁翻譯

3. **競品分析**

   | 專案 | Stars | 特點 | 可借鏡 |
   |------|-------|------|--------|
   | LiveCaptions-Translator | 2,312 | Windows + 多種翻譯 API | Overlay 視窗、歷史記錄、Log Cards |
   | Speech-Translate | 631 | Whisper + 免費翻譯 | 可自訂字幕視窗、批次處理 |
   | Synthalingua | 351 | 即時翻譯 + 字幕 | 人聲隔離 |

### ✅ 凌晨新增功能 (02:10)

1. **HistoryManager.swift**
   - 會議記錄管理
   - 匯出 txt/csv
   - 會議時間計算
   - 字數統計

2. **SettingsView.swift**
   - 字體大小調整 (14-40pt)
   - 自動捲動開關
   - 保持螢幕常亮
   - 顯示時間戳記

3. **ContentView 改進**
   - 新增設定、歷史記錄按鈕
   - 會議計時器顯示
   - 匯出功能 sheet
   - 翻譯防抖動機制

### 🔧 待處理

1. **Xcode 首次設定** (需要 Barry)
   - 執行: `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
   - 或打開 Xcode 讓它自動安裝元件

2. **測試項目**
   - [ ] 實機測試語音辨識準確度
   - [ ] 測試翻譯品質 vs 雲端方案
   - [ ] 測試延遲表現
   - [ ] 測試持續使用穩定性

### 💡 改進建議

根據競品分析，建議未來加入：

1. **歷史記錄功能**
   - 記錄整場會議的對話
   - 可匯出 txt/pdf

2. **字體大小調整**
   - 讓使用者根據距離調整字體

3. **橫向模式**
   - 支援 iPhone 橫放，顯示更多內容

4. **雙語模式**
   - 可同時顯示英文和中文對照

5. **關鍵字高亮**
   - 自動高亮專有名詞或重要詞彙

### 📱 執行方式

Xcode 設定完成後：

```bash
open /Users/barryc/clawd/projects/live-translator-ios/LiveTranslator.xcodeproj
```

然後：
1. 選擇 iPhone 實機
2. Signing & Capabilities → 選擇 Team
3. Cmd + R 執行

### 🔑 注意事項

- 需要實機測試（模擬器不支援麥克風）
- 需要 iOS 17+ 才支援 Translation API
- 需要 Apple Intelligence 支援的裝置才有最佳效果
