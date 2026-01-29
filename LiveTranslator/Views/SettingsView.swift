//
//  SettingsView.swift
//  LiveTranslator
//
//  設定頁面：字體大小、顯示選項
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("englishFontSize") private var englishFontSize: Double = 22
    @AppStorage("chineseFontSize") private var chineseFontSize: Double = 24
    @AppStorage("showTimestamp") private var showTimestamp: Bool = false
    @AppStorage("autoScroll") private var autoScroll: Bool = true
    @AppStorage("keepScreenOn") private var keepScreenOn: Bool = true
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("字體大小") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("英文字體")
                            Spacer()
                            Text("\(Int(englishFontSize)) pt")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $englishFontSize, in: 14...40, step: 2)
                        
                        Text("Preview: Hello, nice to meet you.")
                            .font(.system(size: englishFontSize))
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("中文字體")
                            Spacer()
                            Text("\(Int(chineseFontSize)) pt")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $chineseFontSize, in: 14...40, step: 2)
                        
                        Text("預覽：你好，很高興認識你。")
                            .font(.system(size: chineseFontSize))
                            .foregroundColor(.blue)
                    }
                }
                
                Section("顯示選項") {
                    Toggle("顯示時間戳記", isOn: $showTimestamp)
                    Toggle("自動捲動", isOn: $autoScroll)
                    Toggle("保持螢幕常亮", isOn: $keepScreenOn)
                }
                
                Section("關於") {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("語音辨識")
                        Spacer()
                        Text("Apple Speech")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("翻譯引擎")
                        Spacer()
                        Text("Apple Translation")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button("重置為預設值") {
                        englishFontSize = 22
                        chineseFontSize = 24
                        showTimestamp = false
                        autoScroll = true
                        keepScreenOn = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("設定")
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

#Preview {
    SettingsView()
}
