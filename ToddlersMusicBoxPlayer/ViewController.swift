//
//  ViewController.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 1/27/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import CoreData


class ViewController: UIViewController, AVAudioPlayerDelegate
{
    
    
    
    var avplayer: AVAudioPlayer?
    var musicItem: MusicItem?
    //var engine: AVAudioEngine?
    //var newPlayer: AVAudioPlayerNode?
    var gameTimer: Timer?
    var currentIndex = 0
    var tappedFirstTime = true
    var subviewConstraints: Array<NSLayoutConstraint> = []
    
    var delay: Float = 0
    
    //@IBOutlet var subview: UIView!
    
    
    
    @IBOutlet var subview: UIView!
    @IBOutlet var imageView: UIImageView!    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var downloadedFrom: UIView!
    
    @IBOutlet var sourceLink: UIButton!
    @IBOutlet var dowloadedLabel: UILabel!
    let tapImage = UITapGestureRecognizer()
    //@IBOutlet weak var song2Tapped: UIButton!
    
    /*@IBAction func playButtonTapped(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: "Hi, how are you?")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        //playSound()
        
    }
    
    @IBAction func song2Tapped(_ sender: Any) {
        let url = Bundle.main.url(forResource: "flower", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }

    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup audio session
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.defaultToSpeaker]) // error:nil];
        }
        catch let error as NSError {
            print(error)
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        // load music items
        // Load any saved meals, otherwise load sample data.
        /*if let savedMusiItems = loadMusicItems() {
            musicItems += savedMusiItems
        }
        else {
            // Load the sample data.
            loadSampleMusicItems()
        }*/
        tapImage.addTarget(self, action: "imageTapped")
        imageView.addGestureRecognizer(tapImage)
        
        if let musicItem = musicItem {
            if let name = musicItem.value(forKey: "name") as? String {
                nameLabel.text = name
                nameLabel.numberOfLines = 0
                nameLabel.lineBreakMode = .byWordWrapping
            }
            if let sample = musicItem.value(forKey: "sample") as? String {
                if sample.contains("recording"){
                    playSound(recordingFileName: sample)
                    
                } else {
                    dowloadedLabel.isHidden = false
                    sourceLink.isHidden = false
                    for each in self.view.subviews[0].constraints {
                        if each.identifier == "imageviewtop" {
                            //print("found")
                            each.constant = 0
                        }
                    }
                    playSound(bundleFileName: sample)
                }
            } else {
                if let soundId = musicItem.value(forKey: "soundId") as? UInt64 {
                    /*let myplayer = MPMusicPlayerController.applicationMusicPlayer()
                     myplayer.setQueue(with: sound)
                     myplayer.play()*/
                    if soundId>0 {
                        playSound(soundId: soundId)
                    }
                    
                }
            }
            var image = musicItem.getFirstPhoto()
            //let images = musicItem.value(forKeyPath: "photos") as! NSSet//musicItem.photo
            if image == nil {
                image = UIImage(named:"pic1")! //TODO no image
            }
            imageView.image = image
            /*if musicItem.photo.count>0 {
                imageView.image = musicItem.photo[0]
            }*/
            if (musicItem.photos?.allObjects.count)!>1 {
                
                gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
            } //TODO
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(){
        //print("image tapped")
        //self.view.constraints.
        if tappedFirstTime {
            subviewConstraints = subview.constraints
            nameLabel.removeFromSuperview()
            downloadedFrom.removeFromSuperview()
            subview.removeConstraints(subview.constraints)
            
            //imageView.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: subview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: subview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: subview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            let heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: subview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        
            subview.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            tappedFirstTime = false
        } else {
            
            subview.removeConstraints(subview.constraints)
            
            subview.addSubview(nameLabel)
            subview.addSubview(downloadedFrom)
            
            subview.addConstraints(subviewConstraints)
                        tappedFirstTime = true
        }
        
    }
    /*private func loadMusicItems() -> [MusicItem]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: MusicItem.ArchiveURL.path) as? [MusicItem]
    }
    
    
    
    private func saveMusicItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(musicItems, toFile: MusicItem.ArchiveURL.path)
        if isSuccessfulSave {
            print("Music items successfully saved")
        } else {
            print("Failed to save music items")
        }
    }*/
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    func playSound(url : URL!) {
        do {
            
            /*engine = AVAudioEngine()
             let mainMixer = engine!.mainMixerNode
            newPlayer = AVAudioPlayerNode()
            engine!.attach(newPlayer!)
            let mainMixer = engine!.mainMixerNode
            
            try engine!.start()
            
            engine!.connect(newPlayer!, to: mainMixer, format: mainMixer.outputFormat(forBus: 0))            
            let soundFile = try AVAudioFile.init(forReading: url)
            let delay = getDelayAfterPlaying(url: url)
            print(delay)
            newPlayer!.scheduleFile(soundFile, at: nil, completionHandler: { DispatchQueue.main.async { print("stopped playing");
                self.goBack(afterDelay: delay) } }) //self.performSegue(withIdentifier: "Test", sender: self.imageView)
            
            newPlayer!.play()*/
            avplayer = tryCatch {
                try AVAudioPlayer(contentsOf: url)
            }
            delay = getDelayAfterPlaying(url: url)
            avplayer?.delegate = self
            avplayer?.prepareToPlay()
            avplayer?.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        }

    }
    
    func getDelayAfterPlaying(url: URL) -> Float {
        let audioAsset:AVURLAsset = AVURLAsset(url: url)
        let audioDuration: CMTime = audioAsset.duration
        let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
        var delay: Float
        if audioDurationSeconds < 7 {
            delay = Float(7.0)-Float(audioDurationSeconds)
        } else {
            delay = 0
        }
        return delay
    }
    
    func playSound(bundleFileName: String) {
        if let url = Bundle.main.url(forResource: bundleFileName, withExtension: "mp3") {
            playSound(url: url)
        } else {
            
            self.present(alert(message: "Resource is not available, please contact developer to fix this error",title: "Oops! Sorry, an error has occured"), animated: true, completion: nil)
            //log.error("ViewController.playSound: Bundle.main.url wasn't initialized.")
        }
    }
    
    func playSound(recordingFileName: String) {
        let url : URL = getDocumentsDirectory().appendingPathComponent(recordingFileName)
        //let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        playSound(url: url)
    }
    
    func playSound(soundId: UInt64) {
        let predicate = MPMediaPropertyPredicate(value: soundId, forProperty: MPMediaItemPropertyPersistentID)
        let songQuery = MPMediaQuery()
        songQuery.addFilterPredicate(predicate)
        
        var song: MPMediaItem?
        if let items = songQuery.items, items.count > 0 {
            song = items[0]
        }
        //return song
        //let mediaItem = mediaItemCollection.items.first //TODO
        if let url = song?.assetURL {
            playSound(url: url)
        }
    }
    
    func playSound(mediaItemCollection: MPMediaItemCollection) {
        let mediaItem = mediaItemCollection.items.first //TODO
        if let url = mediaItem?.assetURL {
            playSound(url: url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let player = avplayer {
            if player.isPlaying {
                player.stop()
            }
        }
        gameTimer?.invalidate()

    }
    
    func goBack(afterDelay: Float) {
        gameTimer?.invalidate()
        
        if afterDelay > 0 {
            let sec = Int(afterDelay)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(sec)) {
                self.dismiss(animated: true, completion: nil)
            }
        
        } else {
            self.dismiss(animated: true, completion: nil)}
        
        
        //_ = navigationController!.popToRootViewController(animated: true)
        
    }
    
    
    func changeImage() {
        if let musicItem = musicItem {
            if (musicItem.photos?.count)!>1 {
                // if next image exists
                
                if currentIndex+1 < (musicItem.photos?.count)! {
                    currentIndex = currentIndex + 1
                
                    
                }
                else {
                    currentIndex = 0
                }
                let toImageObject = musicItem.photos?.allObjects[currentIndex]
                let toImage = UIImage(data:(toImageObject as! Photo).value(forKey: "photo") as! Data,scale:1.0)
                UIView.transition(with: self.imageView,
                                  duration:2,
                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                  animations: { self.imageView.image = toImage },
                                  completion: nil)

            
                
            }
        
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        self.goBack(afterDelay: delay)
    }

}

