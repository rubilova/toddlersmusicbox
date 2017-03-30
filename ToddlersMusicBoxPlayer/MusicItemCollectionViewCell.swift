//
//  MusicItemCollectionViewCell.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 2/1/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import UIKit

class MusicItemCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if (imageView != nil) {
            imageView!.image = nil
        }
    }
}
