# 即時翻譯 App (Live Translator)

一個使用 Apple 原生框架的 iOS 即時語音翻譯應用程式，可將英文語音即時辨識並翻譯成繁體中文。

## ✨ 功能特色

- 🎤 **即時語音辨識** - 使用 Apple Speech Framework 辨識英文語音
- 🌐 **即時翻譯** - 使用 Apple Translation Framework 翻譯成繁體中文
- 📱 **簡潔介面** - 上方顯示英文原文，下方顯示中文翻譯
- 🔒 **隱私優先** - 所有處理都在裝置本地進行

## 📋 系統需求

- **iOS 17.0** 或更新版本
- **Xcode 15.0** 或更新版本
- 實體 iPhone/iPad（語音辨識需要麥克風）

## 🚀 如何開啟和執行

### 步驟 1：開啟專案

```bash
# 在終端機執行以下指令開啟 Xcode 專案
open /Users/barryc/clawd/projects/live-translator-ios/LiveTranslator.xcodeproj
```

或者雙擊 `LiveTranslator.xcodeproj` 檔案。

### 步驟 2：設定簽名

1. 在 Xcode 中選擇專案導航器中的 **LiveTranslator** 專案
2. 選擇 **Signing & Capabilities** 標籤
3. 在 **Team** 下拉選單中選擇你的 Apple Developer 帳號
   - 如果沒有帳號，可以使用免費的 Personal Team
   - 前往 Xcode → Settings → Accounts 新增 Apple ID
4. 確保 **Automatically manage signing** 已勾選

### 步驟 3：連接裝置

1. 使用 USB 傳輸線連接你的 iPhone/iPad
2. 在裝置上信任此電腦（如果是第一次連接）
3. 在 Xcode 上方工具列選擇你的裝置

> ⚠️ **注意**：模擬器不支援麥克風，請使用實體裝置測試。

### 步驟 4：執行 App

1. 點擊 Xcode 左上角的 **▶️ Run** 按鈕（或按 `Cmd + R`）
2. 等待編譯和安裝完成
3. App 會自動在裝置上啟動

### 步驟 5：授予權限

首次執行時，App 會要求以下權限：

- **麥克風權限** - 用於錄製語音
- **語音辨識權限** - 用於將語音轉換為文字

請點擊「允許」以啟用所有功能。

## 📖 使用方式

1. 開啟 App 後，點擊藍色的 **「開始」** 按鈕
2. 對著手機說英文
3. 上方會即時顯示辨識的英文文字
4. 下方會自動顯示翻譯後的繁體中文
5. 點擊紅色的 **「停止」** 按鈕結束錄音
6. 點擊 **「清除」** 按鈕可清除所有文字

## 📁 專案結構

```
LiveTranslator/
├── LiveTranslatorApp.swift      # App 進入點
├── Info.plist                   # 權限設定
├── Views/
│   └── ContentView.swift        # 主要 UI 介面
├── Managers/
│   ├── SpeechRecognitionManager.swift  # 語音辨識管理
│   └── TranslationManager.swift        # 翻譯管理
└── Assets.xcassets/             # 資源檔案
```

## 🛠 技術細節

### 使用的框架

| 框架 | 用途 |
|------|------|
| SwiftUI | 使用者介面 |
| Speech | 語音辨識 (SFSpeechRecognizer) |
| Translation | 翻譯 (TranslationSession) |
| AVFoundation | 音訊處理 |

### 架構

- **SpeechRecognitionManager**: 負責麥克風錄音和語音辨識
  - 使用 `SFSpeechAudioBufferRecognitionRequest` 進行即時辨識
  - 支援部分結果回報 (`shouldReportPartialResults`)

- **TranslationManager**: 負責文字翻譯
  - 使用 iOS 17 新的 `Translation` 框架
  - 透過 `TranslationSession` 進行英文到繁體中文翻譯

## ❓ 常見問題

### Q: 為什麼辨識效果不好？
A: 確保在安靜的環境中使用，並清晰地說英文。語音辨識效果會受環境噪音影響。

### Q: 翻譯有延遲怎麼辦？
A: 首次翻譯可能需要下載語言模型。請確保裝置有網路連線，或在設定中預先下載翻譯語言包。

### Q: 可以離線使用嗎？
A: 
- 語音辨識：可以設定 `requiresOnDeviceRecognition = true`，但辨識效果可能較差
- 翻譯：需要先下載語言包才能離線使用

## 📝 License

MIT License

---

Made with ❤️ using Apple's native frameworks
