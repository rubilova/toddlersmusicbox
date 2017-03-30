//
//  CVLayout.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 1/30/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//


import Foundation
import UIKit

class CVLayout: UICollectionViewFlowLayout {
    
    var numberOfColumns : CGFloat!
    var numberOfRows : CGFloat!
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            
            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
                numberOfColumns = 3
                numberOfRows = 2
            } else {
                numberOfColumns = 2
                numberOfRows = 3
            }
            let aSideLength = self.collectionView!.frame.width
            let aSideDivider = numberOfColumns!
            let margin : CGFloat = 5.0
            let aSide = (aSideLength - margin*(aSideDivider+1))/aSideDivider
            let bSideLength = self.collectionView!.frame.height
            let bSideDivider = numberOfRows!
            let bSide = (bSideLength - margin*(bSideDivider+1))/bSideDivider
            
                        return CGSize(width: aSide, height: bSide)
            
            
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 5
        minimumLineSpacing = 5
        //scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)    }
    
    }
