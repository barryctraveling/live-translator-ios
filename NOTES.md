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

**已實作:**
- ✅ 歷史記錄功能
- ✅ 字體大小調整
- ✅ 匯出 txt/csv

**未來可加入:**

1. **WhisperKit 整合**
   - GitHub: argmaxinc/WhisperKit (1.8k stars)
   - 本地 Whisper 模型，辨識更準確
   - 支援 large-v3 模型
   - 需要更大的 App 體積

2. **橫向模式**
   - 支援 iPhone 橫放，顯示更多內容

3. **雙語模式**
   - 可同時顯示英文和中文對照

4. **關鍵字高亮**
   - 自動高亮專有名詞或重要詞彙

5. **語者分離**
   - 辨識不同說話者
   - 使用 pyannote 模型

### 📱 Barry 起床後執行步驟

**1. 完成 Xcode 設定**
```bash
# 打開 Xcode 並完成額外元件安裝
open /Applications/Xcode.app
# 按照提示安裝元件
```

**2. 設定 Xcode 開發者工具**
```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

**3. 打開專案**
```bash
open /Users/barryc/clawd/projects/live-translator-ios/LiveTranslator.xcodeproj
```

**4. 在 Xcode 中:**
- 選擇你的 **iPhone** 作為執行目標（連接實機）
- 點選專案 → **Signing & Capabilities** → 選擇你的 **Team**
- 按 **Cmd + R** 執行

**5. 在 iPhone 上:**
- 允許麥克風權限
- 允許語音辨識權限
- 開始測試！

### 🔑 注意事項

- 需要實機測試（模擬器不支援麥克風）
- 需要 iOS 17+ 才支援 Translation API
- 需要 Apple Intelligence 支援的裝置才有最佳效果
