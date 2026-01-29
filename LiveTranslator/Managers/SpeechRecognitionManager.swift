//
//  SpeechRecognitionManager.swift
//  LiveTranslator
//
//  使用 Apple Speech Framework 進行即時英文語音辨識
//

import Foundation
import Speech
import AVFoundation

@MainActor
class SpeechRecognitionManager: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var isRecording: Bool = false
    @Published var errorMessage: String?
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine: AVAudioEngine?
    
    init() {
        // 使用英文語音辨識器
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        audioEngine = AVAudioEngine()
    }
    
    func requestPermissions() {
        // 請求語音辨識權限
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            Task { @MainActor in
                switch status {
                case .authorized:
                    print("語音辨識權限已授權")
                case .denied:
                    self?.errorMessage = "語音辨識權限被拒絕，請到設定中開啟"
                case .restricted:
                    self?.errorMessage = "語音辨識在此裝置上受限"
                case .notDetermined:
                    self?.errorMessage = "語音辨識權限尚未決定"
                @unknown default:
                    self?.errorMessage = "未知的權限狀態"
                }
            }
        }
        
        // 請求麥克風權限
        AVAudioApplication.requestRecordPermission { [weak self] granted in
            Task { @MainActor in
                if !granted {
                    self?.errorMessage = "麥克風權限被拒絕，請到設定中開啟"
                }
            }
        }
    }
    
    func startRecording() {
        // 確保辨識器可用
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            errorMessage = "語音辨識目前不可用"
            return
        }
        
        // 如果有正在進行的任務，先取消
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // 設定音訊會話
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "無法設定音訊會話: \(error.localizedDescription)"
            return
        }
        
        guard let audioEngine = audioEngine else {
            errorMessage = "音訊引擎未初始化"
            return
        }
        
        // 建立辨識請求
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            errorMessage = "無法建立辨識請求"
            return
        }
        
        // 設定即時回報部分結果
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.addsPunctuation = true
        
        // 使用裝置上的辨識（隱私保護）
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false // 設為 false 可獲得更好的辨識效果
        }
        
        // 取得輸入節點
        let inputNode = audioEngine.inputNode
        
        // 開始辨識任務
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            Task { @MainActor in
                guard let self = self else { return }
                
                if let result = result {
                    // 更新辨識文字
                    self.recognizedText = result.bestTranscription.formattedString
                }
                
                if let error = error {
                    // 忽略取消錯誤
                    let nsError = error as NSError
                    if nsError.domain != "kAFAssistantErrorDomain" || nsError.code != 216 {
                        print("辨識錯誤: \(error.localizedDescription)")
                    }
                    self.stopRecording()
                }
            }
        }
        
        // 設定音訊格式並開始錄音
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        // 啟動音訊引擎
        do {
            audioEngine.prepare()
            try audioEngine.start()
            isRecording = true
        } catch {
            errorMessage = "無法啟動音訊引擎: \(error.localizedDescription)"
            stopRecording()
        }
    }
    
    func stopRecording() {
        // 停止音訊引擎
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        
        // 結束辨識請求
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        // 取消辨識任務
        recognitionTask?.cancel()
        recognitionTask = nil
        
        isRecording = false
        
        // 重置音訊會話
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("無法停用音訊會話: \(error.localizedDescription)")
        }
    }
    
    func clearText() {
        recognizedText = ""
    }
}
