//
//  TestViewController.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 2/2/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import UIKit
import MediaPlayer

class TestViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var playButton: UIButton!
    var recorder:AVAudioRecorder?
    var player:AVAudioPlayer?
    var engine : AVAudioEngine?
    var newPlayer : AVAudioPlayerNode?
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if (player == nil) {}
        else
        {
            if (player!.isPlaying) {
                player!.stop()
            }
        }
        
        if (!(recorder?.isRecording)!) {
            let session:AVAudioSession = AVAudioSession.sharedInstance()
            do {
                try session.setActive(true) }
            catch let error as NSError {
                print(error)
            }
            
            // Start recording
            recorder?.record()
            recordButton.setTitle("Pause", for:UIControlState.normal)
            
        } else {
            
            // Pause recording
            recorder?.pause()
            recordButton.setTitle("Record", for:UIControlState.normal)
        }
        
        stopButton.isEnabled = true
        playButton.isEnabled = false
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        recorder?.stop()
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        do {
        try audioSession.setActive(false)
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if (!(recorder?.isRecording)!){
            
            /*player = try AVAudioPlayer(contentsOf: (recorder?.url)!)//[[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
            player?.delegate = self
                player?.play() }*/
 
            engine = AVAudioEngine()
            //engine.prepare()
            //let outputNode = engine.outputNode
            //engine.disconnectNodeInput(inputNode!)
            newPlayer = AVAudioPlayerNode()
            engine?.attach(newPlayer!)
            let mainMixer = engine?.mainMixerNode
            do {
                try engine?.start()
            }
            catch let error as NSError {
                print(error)
            }
            engine?.connect(newPlayer!, to: mainMixer!, format: mainMixer!.outputFormat(forBus: 0))
            let url = Bundle.main.url(forResource: "ItsyBitsySpider", withExtension: "mp3")!
            do {
                let soundFile = try AVAudioFile.init(forReading: url) //(recorder?.url)!
                newPlayer?.scheduleFile(soundFile, at: nil, completionHandler: { DispatchQueue.main.async { print("stopped playing") } }) //self.performSegue(withIdentifier: "Test", sender: self.imageView)
            }
            catch let error as NSError {
                print(error)
            }
            newPlayer?.play()
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable Stop/Play button when application launches
        stopButton.isEnabled = false // setEnabled:NO];
        playButton.isEnabled = false // setEnabled:NO];
        
        // Set the audio file
        /*NSArray pathComponents = [NSArray arrayWithObjects:
            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
            @"MyAudioMemo.m4a",
             nil];*/
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let newName = "recording" + NSUUID().uuidString + ".m4a"
        let outputFileURL:URL = documentsDirectory.appendingPathComponent(newName)
        
        // Setup audio session
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        do {
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord) // error:nil];
        }
        catch let error as NSError {
            print(error)
        }
        
        // Define the recorder setting
        //NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        let recordSetting:NSMutableDictionary = NSMutableDictionary()
        recordSetting.setValue(Int(kAudioFormatMPEG4AAC), forKey: AVFormatIDKey)
        recordSetting.setValue(Float(44100.0), forKey:AVSampleRateKey)
        recordSetting.setValue(2, forKey:AVNumberOfChannelsKey)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2
        ] as [String : Any]
 
        // Initiate and prepare the recorder
        do {
            recorder = try AVAudioRecorder(url: outputFileURL, settings: settings)
            recorder?.delegate = self;
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
        }
        catch let error as NSError {
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func audioRecorderDidFinishRecording(avrecorder: AVAudioRecorder)
    {
        recordButton.setTitle("Record", for: UIControlState.normal)
        stopButton.isEnabled = false
        playButton.isEnabled = true
    }*/
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordButton.setTitle("Record", for: UIControlState.normal)
            stopButton.isEnabled = false
            playButton.isEnabled = true
        }
    }
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer)
    {
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
    message: @"Finish playing the recording!"
    delegate: nil
    cancelButtonTitle:@"OK"
    otherButtonTitles:nil];
    [alert show];*/
        print("finished playing")
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
