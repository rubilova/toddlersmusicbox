//
//  Playset+CoreDataProperties.swift
//  
//
//  Created by Yelena Rubilova on 5/23/17.
//
//

import Foundation
import CoreData


extension Playset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playset> {
        return NSFetchRequest<Playset>(entityName: "Playset")
    }

    @NSManaged public var blocked: Bool
    @NSManaged public var localId: String?
    @NSManaged public var name: String?
    @NSManaged public var ratingLocal: Float
    @NSManaged public var ratingServer: Float
    @NSManaged public var shared: Bool
    @NSManaged public var type: String?
    @NSManaged public var uid: String?
    @NSManaged public var version: String?
    @NSManaged public var language: String?
    @NSManaged public var musicItems: NSOrderedSet?

}

// MARK: Generated accessors for musicItems
extension Playset {

    @objc(insertObject:inMusicItemsAtIndex:)
    @NSManaged public func insertIntoMusicItems(_ value: MusicItem, at idx: Int)

    @objc(removeObjectFromMusicItemsAtIndex:)
    @NSManaged public func removeFromMusicItems(at idx: Int)

    @objc(insertMusicItems:atIndexes:)
    @NSManaged public func insertIntoMusicItems(_ values: [MusicItem], at indexes: NSIndexSet)

    @objc(removeMusicItemsAtIndexes:)
    @NSManaged public func removeFromMusicItems(at indexes: NSIndexSet)

    @objc(replaceObjectInMusicItemsAtIndex:withObject:)
    @NSManaged public func replaceMusicItems(at idx: Int, with value: MusicItem)

    @objc(replaceMusicItemsAtIndexes:withMusicItems:)
    @NSManaged public func replaceMusicItems(at indexes: NSIndexSet, with values: [MusicItem])

    @objc(addMusicItemsObject:)
    @NSManaged public func addToMusicItems(_ value: MusicItem)

    @objc(removeMusicItemsObject:)
    @NSManaged public func removeFromMusicItems(_ value: MusicItem)

    @objc(addMusicItems:)
    @NSManaged public func addToMusicItems(_ values: NSOrderedSet)

    @objc(removeMusicItems:)
    @NSManaged public func removeFromMusicItems(_ values: NSOrderedSet)

}
