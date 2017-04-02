//
//  MediaPickerViewController.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 1/28/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

//import UIKit
import MediaPlayer
import DKImagePickerController
import CoreData
import Photos

class MusicItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MPMediaPickerControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var selectSoundButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var selectedSoundLabel: UILabel!
    @IBOutlet var selectImagesButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
        //@IBOutlet var musicItemNameLabel: UILabel!
    var mediapicker1 : MPMediaPickerController?
    var selectedSound : MPMediaItemCollection?
    var selectedSoundId : UInt64 = 0
    var selectedSoundURL: URL?
    var selectedRecordingURL: URL?
    var selectedPhotos: Array<PhotoAsset> = []
    var didSelectPhotos: Bool = false
    
    //var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var selectedSample: String?
    var audioFilename: URL?
    var recordingName: String?
    var player: AVAudioPlayer?
    
    
    var musicItem: MusicItem?
    
    @IBAction func selectMedia(_ sender: Any) {
        self.present(mediapicker1!, animated: true, completion: nil)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if playButton.currentTitle == "Play" {
            /*do {
                player = try AVAudioPlayer(contentsOf: selectedSoundURL!)
            } catch let error as NSError {
                print(error)
            }*/
            player = tryCatch {
                try AVAudioPlayer(contentsOf: selectedSoundURL!)
            }
            player?.delegate = self
            player?.play()
            //playSound(url: selectedSoundURL!, completionHandler: { DispatchQueue.main.async {self.playButton.setTitle("Play", for: UIControlState.normal)}})
            playButton.setTitle("Stop", for: UIControlState.normal)
        } else {
            if (player?.isPlaying)! {
                player?.stop()
            }
            playButton.setTitle("Play", for: UIControlState.normal)
            
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if (!(audioRecorder?.isRecording)!) {
            let session:AVAudioSession = AVAudioSession.sharedInstance()
            do {
                try session.setActive(true) }
            catch let error as NSError {
                print(error)
            }
            
            // Start recording
            audioRecorder?.record()
            recordButton.setTitle("Tap to Stop", for: .normal)
            
        } else {
            
            // Stop recording
            audioRecorder!.stop()
            let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(false)
            } catch let error as NSError {
                print(error)
            }
            
            recordButton.setTitle("Record", for:UIControlState.normal)
        }
        
        
        /*if audioRecorder == nil {
         startRecording()
         } else {
         finishRecording(success: true)
         }*/
        
    }

    
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: Any) {
        let pickerController = DKImagePickerController()
        pickerController.allowsLandscape = true
        pickerController.showsCancelButton = true
        var selectedAssets: Array<DKAsset> = []
        for each in selectedPhotos {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let asset = PHAsset.fetchAssets(withLocalIdentifiers: [each.assetId!], options: fetchOptions)
            //let asset:PHAsset =
            let dkasset = DKAsset(originalAsset: asset.firstObject!)
            selectedAssets.append(dkasset)
            
        }
        pickerController.defaultSelectedAssets = selectedAssets
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            //print("didSelectAssets")
            //var assetsIdentifiers: Array<String> = []
            self.selectedPhotos = []
            self.didSelectPhotos = true
            self.collectionView.reloadData()
            for each in assets {
                /*each.fetchOriginalImage(false){
                    (image: UIImage, nil) in
                    self.selectedPhoto = image
                }*/
                //var selectedImage:UIImage
                each.fetchOriginalImageWithCompleteBlock({ (image, info) in //TODO: what if fetch is not ready when we save?
                    //self.selectedPhoto.append(image!)
                    //selectedImage = image!//UIImageJPEGRepresentation(image!,1.0) as NSData?//image
                    let photo = PhotoAsset(photo: image!, assetId: each.localIdentifier)
                    self.selectedPhotos.append(photo)
                    
                    self.reloadDataWhenAllReady(assetsCount: assets.count)
                })
                
                
            }
            
            //print(assets)
        }
        
        self.present(pickerController, animated: true) {}

    }
    func reloadDataWhenAllReady(assetsCount: Int){
        if selectedPhotos.count == assetsCount {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let's make buttons round
        selectSoundButton.layer.cornerRadius = 4
        recordButton.layer.cornerRadius = 4
        playButton.layer.cornerRadius = 4
        selectImagesButton.layer.cornerRadius = 4
        
        
        // initialize media picker
        let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
        mediaPicker.allowsPickingMultipleItems = false
        mediapicker1 = mediaPicker
        mediaPicker.delegate = self
        
        // set UI controls if editing existing music item
        if let musicItem = musicItem {
            //musicItemNameLabel.text = musicItem.value(forKey: "name") as? String
            //print(musicItem.sample)
            selectedSoundLabel.text = musicItem.name
            selectedSoundURL = musicItem.getSoundURL()
            selectedPhotos = musicItem.getPhotoAssets()
                
            
        }
        
        
        // initialize recording
        initializeRecording()
        if selectedSoundURL == nil {
            disableButton(button: playButton)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        /*if section == 0 {
         return 6}//musicItems.count}
         else {
         return 1
         }*/
        return selectedPhotos.count//itemsOnTheScreen
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
         
         // Configure the cell
         
         return cell*/
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedImageCell", for: indexPath)
        let image = selectedPhotos[indexPath.row].photo
        let imageView = cell.contentView.subviews.first as! UIImageView
        imageView.image = image
        //UIImageView(image: image)
        //subview.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        //imageView.isUserInteractionEnabled = true
        //var image = UIImage(named: "myImage.jpg");
        //cell.contentView.backgroundColor = UIColor.blue
        
        //cell.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.topMargin, multiplier: 1, constant: 0)
        
        cell.contentView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 140, height: 140);
    }

    
    func initializeRecording() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        recordingName = "recording" + NSUUID().uuidString + ".m4a"
        let outputFileURL:URL = documentsDirectory.appendingPathComponent(recordingName!)
        
        // Setup audio session
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.defaultToSpeaker]) // error:nil];
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
            audioRecorder = try AVAudioRecorder(url: outputFileURL, settings: settings)
            selectedRecordingURL = outputFileURL
            audioRecorder?.delegate = self;
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        }
        catch let error as NSError {
            print(error)
        }

    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("Play", for: UIControlState.normal)
    }
    
    func recordTapped() {
            }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            selectedSample = recordingName!
            selectedSoundLabel.text = "Recording.m4a"//recordingName! TODO
            selectedSoundURL = selectedRecordingURL
            selectedSoundLabel.sizeToFit()
            enableButton(button: playButton)
            //finishRecording(success: false) //TODO: if recording was interrupted by phone call
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        if selectedPhotos.count == 0 {
            self.present(alert(message: "Please select at least one photo",title: "An error occured while saving an item"), animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button == saveButton else {
            print("The save button was not pressed, cancelling")
            return
        }
        
        /*guard let musicItem?.photos.count > 0 else {
            print("The save button was not pressed, cancelling")
            return
        }*/
        
        var name: String
        if let selectedSoundLabelText = selectedSoundLabel.text {
            name = selectedSoundLabelText
        } else {
            name = ""
        }
        //var photo = musicItem?.photo
        /*let photo = selectedPhoto //TODO
        var sound = musicItem?.value(forKey: "sound")
        if selectedSound != nil {
            sound = selectedSound }
        
        musicItem = MusicItem(name: name, photo: photo, sound: sound, sample: nil)*/
        if let musicItem = musicItem { // existing item
            //musicItemNameLabel.text = musicItem.value(forKey: "name") as? String
            if selectedSoundId == 0 {
                if musicItem.soundId > 0 {
                    selectedSoundId = UInt64(musicItem.soundId)
                }
            }
            
            /*if selectedSample == nil {} else {
                musicItem.sample = selectedSample
            }*/
            if didSelectPhotos {
                musicItem.save(name: name, photos: selectedPhotos, soundId: selectedSoundId, sample: selectedSample)
            } else {
                musicItem.save(name: name, soundId: selectedSoundId, sample: selectedSample)
            }
            //MusicItem.save(name: name, photos: selectedPhoto, soundId: selectedSoundId, sample: "recording.m4a")
            
        }else { // new item
            
            musicItem = MusicItem.save(name: name, photos: selectedPhotos, soundId: selectedSoundId, sample: selectedSample)
        }
    }
    
    
    
        
    
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        //musicItem?.value(forKey: "sound") = mediaItemCollection
        
        let songId = (mediaItemCollection.items.first?.persistentID)! as UInt64
        selectedSoundURL = mediaItemCollection.items.first?.assetURL
        mediapicker1!.dismiss(animated: true, completion: nil)
        selectedSoundLabel.text = mediaItemCollection.items[0].title
        selectedSoundLabel.sizeToFit()
        enableButton(button: playButton)
        //print("you picked: \(mediaItemCollection)")
        /*let myplayer = MPMusicPlayerController.applicationMusicPlayer()
        myplayer.setQueue(with: mediaItemCollection)
        myplayer.play()*/
        selectedSoundId = songId
        
        //let vc = MainView(nibName: "MainView", bundle: nil)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController){
        mediapicker1!.dismiss(animated: true, completion: nil)
        print("Cancel")
        
    }
    
    
    
}
