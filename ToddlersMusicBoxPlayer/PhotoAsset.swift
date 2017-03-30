//
//  PhotoAsset.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 3/1/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import Foundation
import UIKit

class PhotoAsset: NSObject {
    var photo: UIImage?
    var assetId: String?
    
    init(photo: UIImage?, assetId: String?){
        self.photo = photo
        self.assetId = assetId
    }
    
}
