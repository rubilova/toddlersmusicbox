//
//  MusicItem+CoreDataProperties.swift
//  
//
//  Created by Yelena Rubilova on 5/23/17.
//
//

import Foundation
import CoreData


extension MusicItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicItem> {
        return NSFetchRequest<MusicItem>(entityName: "MusicItem")
    }

    @NSManaged public var img: String?
    @NSManaged public var localId: String?
    @NSManaged public var name: String?
    @NSManaged public var soundId: Int64
    @NSManaged public var soundURL: String?
    @NSManaged public var creditLabel: String?
    @NSManaged public var photos: NSOrderedSet?
    @NSManaged public var playset: Playset?

}

// MARK: Generated accessors for photos
extension MusicItem {

    @objc(insertObject:inPhotosAtIndex:)
    @NSManaged public func insertIntoPhotos(_ value: Photo, at idx: Int)

    @objc(removeObjectFromPhotosAtIndex:)
    @NSManaged public func removeFromPhotos(at idx: Int)

    @objc(insertPhotos:atIndexes:)
    @NSManaged public func insertIntoPhotos(_ values: [Photo], at indexes: NSIndexSet)

    @objc(removePhotosAtIndexes:)
    @NSManaged public func removeFromPhotos(at indexes: NSIndexSet)

    @objc(replaceObjectInPhotosAtIndex:withObject:)
    @NSManaged public func replacePhotos(at idx: Int, with value: Photo)

    @objc(replacePhotosAtIndexes:withPhotos:)
    @NSManaged public func replacePhotos(at indexes: NSIndexSet, with values: [Photo])

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSOrderedSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSOrderedSet)

}
