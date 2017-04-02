//
//  MusicItemExtension.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 2/19/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MediaPlayer
import Photos

extension MusicItem {
    // new functionality to add to SomeType goes here
    func getFirstPhoto() -> UIImage? {
        let images = (self.value(forKeyPath: "photos") as! NSOrderedSet).array
        if images .count > 0 {
            let image = UIImage(data:(images.first as! NSObject).value(forKey: "photo") as! Data,scale:1.0)
            return image
        } else {
            return nil
        }
    }
    
    static func delete(musicItem : MusicItem){
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        // 1
        let managedContext =
            appDelegate.managedObjectContext
        // 2
        managedContext.delete(musicItem)
        do {
            try managedContext.save()
            //musicItems.append(musicItem) TODO: move deletion here
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return
        
    }
    
    static func save(name: String, photos: Array<PhotoAsset>, soundId: UInt64, sample: String?) -> MusicItem {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        // 1
        let managedContext =
            appDelegate.managedObjectContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "MusicItem",
                                       in: managedContext)!
        
        let musicItem = MusicItem(entity: entity,
                                  insertInto: managedContext)
        
        // 3
        musicItem.setValue(name, forKeyPath: "name")
        musicItem.setValue(sample, forKeyPath: "sample")
        musicItem.setValue(soundId, forKeyPath: "soundId")
        var valueArray: [Photo] = []
        for i in 0...photos.count-1 {
            
            //let image = UIImage(named: "pic1")
            let photoAsset:PhotoAsset = photos[i]
            let entityDescription = NSEntityDescription.entity(forEntityName: "Photo",in: managedContext)!
            let photo = Photo(entity: entityDescription, insertInto: managedContext)
            photo.photo = UIImageJPEGRepresentation(photoAsset.photo!,1.0) as NSData?
            photo.assetId = photoAsset.assetId
            //musicItem.insertIntoPhotos([photo], at: [i])//.addToPhotos(photo)
            valueArray.append(photo)
        }
        var set = musicItem.mutableOrderedSetValue(forKey: "photos")
        //                set.removeAllObjects()
        set.addObjects(from: valueArray)
        // 4
        do {
            try managedContext.save()
            musicItems.append(musicItem)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return musicItem
    }
    
    func save(name: String, photos: Array<PhotoAsset>, soundId: UInt64, sample: String?) {
    
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
    
        // 1
        let managedContext =
            appDelegate.managedObjectContext
    
        // 2
        //let entity = NSEntityDescription.entity(forEntityName: "MusicItem", in: managedContext)!
        
        // 3
        self.name = name
        //musicItem.setValue(photo, forKeyPath: "photo")
        self.soundId = Int64(soundId)
        self.sample = sample
        /*if (self.photos?.count)! > 0 {
            self.removeFromPhotos(self.photos!)
        }*/
        var valueArray: [Photo] = []
        for i in 0...photos.count-1 { //TODO: "no photo" image
            let photoAsset:PhotoAsset = photos[i]
            let entityDescription = NSEntityDescription.entity(forEntityName: "Photo",in: managedContext)!
            let photo = Photo(entity: entityDescription, insertInto: managedContext)
            photo.photo = UIImageJPEGRepresentation(photoAsset.photo!,1.0) as NSData?
            photo.assetId = photoAsset.assetId
            //self.addToPhotos(photo)
            valueArray.append(photo)
        }
        var set = self.mutableOrderedSetValue(forKey: "photos")
        set.removeAllObjects()
        set.addObjects(from: valueArray)
        // 4
        do {
            try managedContext.save()
            //musicItems.append(musicItem)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getPhotoAssets() -> Array<PhotoAsset> {
        var result: Array<PhotoAsset> = []
        for each in (photos?.array)! {
            let photo = each as! Photo
            let photoAsset = PhotoAsset(photo: UIImage(data: photo.photo as! Data,scale:1.0) , assetId: photo.assetId)
            result.append(photoAsset)
        }
        return result
    }
    
    func save(name: String, soundId: UInt64, sample: String?) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.managedObjectContext
        
        // 2
        //let entity = NSEntityDescription.entity(forEntityName: "MusicItem", in: managedContext)!
        
        // 3
        self.name = name
        //musicItem.setValue(photo, forKeyPath: "photo")
        self.soundId = Int64(soundId)
        self.sample = sample
        // 4
        do {
            try managedContext.save()
            //musicItems.append(musicItem)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    

    
    func getSoundURL() -> URL? {
        var result: URL?
        if let sample = self.sample {
            if sample.contains("recording"){
                result = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(sample)
                
            } else {
                result = Bundle.main.url(forResource: sample, withExtension: "mp3")!
            }
        } else
        {
                
            if self.soundId>0 {
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
                        result = url
                    }
                    
            }
                
            
        }
        return result
        
    }

}
