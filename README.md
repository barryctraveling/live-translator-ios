# 📱 Live Translator iOS

即時英翻中 App - 使用 Apple 本地語音辨識和翻譯

## ✨ 功能特色

- 🎤 **即時語音辨識** - Apple Speech Framework (本地處理)
- 🀄 **即時翻譯** - Apple Translation API (iOS 17+)
- 📝 **英文持續累積** - 不會清空，一直顯示
- 💾 **會議記錄** - 記錄整場會議對話
- 📤 **匯出功能** - 支援 txt/csv 格式
- ⚙️ **可自訂設定** - 字體大小、自動捲動、螢幕常亮

## 📱 系統需求

- iOS 17.0 或以上
- iPhone / iPad
- 支援 Apple Intelligence 的裝置效果最佳

## 🚀 安裝方式

1. **Clone 專案**
   ```bash
   git clone https://github.com/barryctraveling/live-translator-ios.git
   ```

2. **打開 Xcode**
   ```bash
   open LiveTranslator.xcodeproj
   ```

3. **設定簽名**
   - 選擇專案 → Signing & Capabilities
   - 選擇你的 Team

4. **執行**
   - 連接 iPhone (模擬器不支援麥克風)
   - 按 Cmd + R

## 📖 使用方式

1. 點擊「🎤 開始翻譯」
2. 對方說英文
3. 上方即時顯示英文，下方顯示中文翻譯
4. 點擊「⏹️ 停止」結束
5. 可匯出會議記錄

## 📁 專案結構

```
LiveTranslator/
├── LiveTranslatorApp.swift      # App 進入點
├── Views/
│   ├── ContentView.swift        # 主畫面
│   └── SettingsView.swift       # 設定頁面
├── Managers/
│   ├── SpeechRecognitionManager.swift  # 語音辨識
│   ├── TranslationManager.swift        # 翻譯
│   └── HistoryManager.swift            # 歷史記錄
├── Assets.xcassets/             # 資源
└── Info.plist                   # 權限設定
```

## 🔐 權限說明

- **麥克風** - 語音辨識需要
- **語音辨識** - 將語音轉為文字

## 💡 與 Web 版比較

| 項目 | iOS App | Web 版 |
|------|---------|--------|
| 語音辨識 | Apple Speech | Deepgram |
| 翻譯 | Apple Translation | GPT-4o-mini |
| 延遲 | < 0.5 秒 | 1-2 秒 |
| 費用 | 免費 | ~$0.66/小時 |
| 離線 | ✅ | ❌ |

## 📄 License

MIT
