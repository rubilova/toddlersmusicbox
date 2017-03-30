//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Yelena Rubilova on 3/1/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photo: NSData?
    @NSManaged public var assetId: String?
    @NSManaged public var musicItem: MusicItem?

}
