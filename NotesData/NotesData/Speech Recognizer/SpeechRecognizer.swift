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
    
    func speechRecognized(_ text: String, error: Error?)
    
    func recognizerStopListen()
    
    func recognizerStartListen()
    
    func speechReconizer(availabilityDidChange available: Bool)
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
    }
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private var audioEngine = AVAudioEngine()
    
    var delegate: SpeechRecognitionDelegate?
    
    func authorizeSpeechRecognition() {
        self.speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if let delegate = self.delegate {
                delegate.authorizationResponse(SpeechRecognizer.SpeechRecognizerAuthorizationStatus(authStatus))
            }
        }
    }
    
    func stopRecognize() {
        if self.audioEngine.isRunning {
            self.audioEngine.stop()
            self.audioEngine.reset()
            self.recognitionRequest?.endAudio()
            self.recognitionTask?.finish()
            self.recognitionRequest = nil
            self.recognitionTask = nil
        }
    }
    
    func startRecognize() {
        
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
            print(error)
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let inputNode = audioEngine.inputNode else {
            //TODO: Error with text "Audio engine has no input node"
            return
        }
        
        guard let recognitionRequest = recognitionRequest else {
            //TODO: Error with text "Unable to created a SFSpeechAudioBufferRecognitionRequest object"
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
                print("Recognized text \(recognizedText)")
                
                delegate.speechRecognized(recognizedText, error: nil)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                delegate.recognizerStopListen()
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
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
            print(error)
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
