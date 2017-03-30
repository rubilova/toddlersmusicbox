//
//  MusicItem.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 1/28/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

/*import UIKit
import MediaPlayer

class MusicItem: NSObject, NSCoding {
    
    var name: String
    //var photo: UIImage?
    var photo: Array<UIImage> = []
    var sound: MPMediaItemCollection?
    var sample: String?
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let sound = "sound"
        static let sample = "sample"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("musicItems")
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            //os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as! [UIImage]
        
        let sound = aDecoder.decodeObject(forKey: PropertyKey.sound) as? MPMediaItemCollection
        let sample = aDecoder.decodeObject(forKey: PropertyKey.sample) as? String
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, sound: sound, sample: sample)
        
    }
    
    init?(name: String, photo: [UIImage], sound: MPMediaItemCollection?, sample: String?) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        /* TODO
        // The rating must be between 0 and 5 inclusively
        guard (sound >= 0) && (sound <= 5) else {
            return nil
        }
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || sound < 0  {
            return nil
        }*/
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.sound = sound
        self.sample = sample
        
    }

    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(sound, forKey: PropertyKey.sound)
        aCoder.encode(sample, forKey: PropertyKey.sample)
    }
    
}*/
