//
//  SpeechRecognizer.swift
//  NotesData
//
//  Created by mini on 10/21/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation

import Speech

protocol SpeechRecognitionDelegate {

    func authorizationResponse(_ status: SpeechRecognizer.SpeechRecognizerAuthorizationStatus)
    
    func speechRecognized(_ text: String, error: Error?, isFinalText: Bool)
    
    func recognizerStopListen()
    
    func recognizerStartListen()
    
    func speechReconizer(availabilityDidChange available: Bool)
    
    func handle(_ error: Error)
}

class SpeechRecognizer: NSObject {
    
    var isStart:Bool {
        get {
            return self.audioEngine.isRunning
        }
    }
    
    internal enum SpeechRecognizerAuthorizationStatus : Int {
        
        case notDetermined
        
        case denied
        
        case restricted
        
        case authorized
        
        init(_ status: SFSpeechRecognizerAuthorizationStatus) {
            switch status {
            case .authorized:
                self = .authorized
                
            case .denied:
                self = .denied

            case .restricted:
                self = .restricted
                
            case .notDetermined:
                self = .notDetermined
                
            }
        }
        
        func description() -> String {
            switch self {
            case .authorized:
                return "Speech recognition - allowed"
                
            case .denied:
                return "Speech recognition - "
                
            case .restricted:
                return "Speech recognition - restricted"
                
            case .notDetermined:
                return "Speech recognition - not determined"
                
            }
        }
    }
    
    private(set) var authorizedStatus = SpeechRecognizerAuthorizationStatus.notDetermined
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: NSLocale.preferredLanguages[0]))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private var audioEngine = AVAudioEngine()
    
    var delegate: SpeechRecognitionDelegate?
    
    func authorizeSpeechRecognition() {
        self.speechRecognizer.delegate = self

        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if let delegate = self.delegate {
                self.authorizedStatus = SpeechRecognizerAuthorizationStatus(authStatus)
                delegate.authorizationResponse(self.authorizedStatus)
            }
        }
    }
    
    func stopRecognize() {
        if self.audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
        }
    }
    
    func startRecognize() {
        
        guard let delegate = self.delegate else {
            return
        }
        
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)

        } catch {
            delegate.handle(error)
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let inputNode = audioEngine.inputNode else {
            return
        }
        
        guard let recognitionRequest = recognitionRequest else {
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            guard let delegate = self.delegate else {
                self.audioEngine.stop()
                return
            }
            
            if let result = result {
                let recognizedText = result.bestTranscription.formattedString
                isFinal = result.isFinal
                
                delegate.speechRecognized(recognizedText, error: nil, isFinalText: isFinal)
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                delegate.recognizerStopListen()
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                if error != nil {
                    delegate.handle(error!)
                }
                
            }
            
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            delegate.handle(error)
        }
        
        if let delegate = self.delegate {
            delegate.recognizerStartListen()
        }
        
    }
    
}

extension SpeechRecognizer:  SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        guard let delegate = delegate else {
            return
        }
        
        if available {
            delegate.speechReconizer(availabilityDidChange: true)
        } else {
            delegate.speechReconizer(availabilityDidChange: false)
        }
    }
}
