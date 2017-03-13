//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Tigran Tshorokhyan on 3/8/17.
//  Copyright © 2017 Tigran Tshorokhyan. All rights reserved.
//

import UIKit
//recording addition
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    // Alerts
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    
    //recording addition
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
        
   
        
    //Per project review creating refactoring method.
    func setUIState(recButton:Bool, stopButton:Bool) {
        recordButton.isEnabled = recButton
        stopRecordingButton.isEnabled = stopButton
        if recButton {
            recordLabel.text = "Tap to Record"
        } else {
            recordLabel.text = "Recording..."
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIState(recButton: true, stopButton: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
    }

    @IBAction func recordAudio(_ sender: Any) {
        setUIState(recButton: false, stopButton: true)
        //recording addition
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        setUIState(recButton: true, stopButton: false)
        //recording addition
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
   func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print(Alerts.RecordingDisabledMessage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

