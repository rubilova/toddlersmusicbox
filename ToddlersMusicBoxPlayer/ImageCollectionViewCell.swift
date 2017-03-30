//
//  ImageCollectionViewCell.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 1/30/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil //TODO
    }
}

