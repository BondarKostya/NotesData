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

    func authorizationResponse(withStatus: SpeechRecognizer.SpeechRecognizerAuthorizationStatus)
}

class SpeechRecognizer: NSObject {
    
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
    
    private let audioEngine = AVAudioEngine()
    
    var delegate: SpeechRecognitionDelegate?
    
    func authorizeSpeechRecognition() {
        self.speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if let delegate = self.delegate {
                delegate.authorizationResponse(withStatus: SpeechRecognizer.SpeechRecognizerAuthorizationStatus(authStatus))
            }
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
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, delegate: self)
        
        
        
    }
    
}

extension SpeechRecognizer: SFSpeechRecognitionTaskDelegate {
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didHypothesizeTranscription transcription: SFTranscription) {
        
        
        if task.error != nil && task.isFinishing {
            let text = transcription.formattedString
            //TODO: delegate call with recongized string
            
            
            
        }
    }
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
        if !successfully {
            //TODO: Error with recognition - task.error
        } else {
            //task.
        }
        
    }
}

extension SpeechRecognizer:  SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
    }
}
