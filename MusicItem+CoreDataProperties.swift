//
//  MusicItem+CoreDataProperties.swift
//  
//
//  Created by Yelena Rubilova on 2/19/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension MusicItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicItem> {
        return NSFetchRequest<MusicItem>(entityName: "MusicItem");
    }

    @NSManaged public var name: String?
    @NSManaged public var soundId: Int64
    @NSManaged public var sample: String?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension MusicItem {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
    
    

}
