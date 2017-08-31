//
//  ViewController.swift
//  textSpeech_iOS
//
//  Created by Edson  Jr on 30/08/17.
//  Copyright © 2017 Edson  Jr. All rights reserved.
//
//
//FOR MOR INFOS: https://www.youtube.com/watch?v=2gs5QTRC8Yk&t=388s




import UIKit
import Speech
import AVFoundation



class ViewController: UIViewController,AVAudioPlayerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var audioPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playAndTranscribe(_ sender: Any) {
        
        requestSpeechAuth() //calling the function to play audio and transcribe to text
        
    }
    
    //Mark: Funcao para autorizar speech 
    func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                if let path = Bundle.main.url(forResource: "portugues3", withExtension: "m4a") {
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                    }catch {
                        print("Erro in play audio")
                        self.textView.text = "Error in Play and Transcribe!"
                    }
                    
                    //creating the speech recognizer
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request) { (result, error) in
                        if let error = error {
                            print("There was error: \(error)")
                        }else {
                            print(result?.bestTranscription.formattedString) //print the audio recognized and transcribed to text
                             self.textView.text = result?.bestTranscription.formattedString
                        }
                       
                    }
                }
            }
        }
    }
    
    
    func audioPlayerDidFinishPlay(_ player: AVAudioPlayer,successfully flag: Bool){
        player.stop()
        print("Player stoped")
    }

}

