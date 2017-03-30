//
//  CVDataSource.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 2/15/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import UIKit
import CoreData

class CVDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    var page: Int = 0
    var itemsCount: Int!
    var collectionView: UICollectionView!
    var parentViewController: PlayerViewController!
    
    init(page: Int, cv: UICollectionView, vc: PlayerViewController) {
        // perform some initialization here
        super.init()
        self.page = page
        self.collectionView = cv
        let tapGestureRecognizer = UILongPressGestureRecognizer(target:self, action: #selector(CVDataSource.handleLongPress))
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.addGestureRecognizer(tapGestureRecognizer)
        self.parentViewController = vc
        //self.parentViewController.deleteButton.addTarget(self, action: #selector(CVDataSource.deleteButtonTapped),
                                                         //for:.touchUpInside)
        //self.coll.indexpa
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("section \(section)")
        //print("items on \(page) = \(itemsCount)")
        return itemsCount
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
         
         // Configure the cell
         
         return cell*/
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell\(page)", for: indexPath) as! MusicItemCollectionViewCell
        //let page = collectionView.layer.value(forKey: "page") as! Int
        //print("cell on \(page)")
        let musicItem = getItem(currentPage: page, index: indexPath.row)
        var image = musicItem.getFirstPhoto()
        //let images = musicItem.value(forKeyPath: "photos") as! NSSet//musicItem.photo
        if image == nil {
            image = UIImage(named:"pic1")! //TODO no image
        }
        let imageView = UIImageView(image: image)
        //subview.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        //imageView.isUserInteractionEnabled = true
        //var image = UIImage(named: "myImage.jpg");
        //cell.contentView.backgroundColor = UIColor.blue
        
        cell.contentView.addSubview(imageView)
        cell.imageView = imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //setTranslatesAutoresizingMaskIntoConstraints
        let horizontalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.topMargin, multiplier: 1, constant: 0)
        
        cell.contentView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        return cell
        
    }
    
    private func getItem(currentPage: Int, index: Int) -> MusicItem {
        return musicItems[currentPage*6+index]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let selectedItem = musicItems[page*6+indexPath.row]
        //if (selectedItem.photos?.count)!>1 {
        let scrollView: UIScrollView = collectionView.superview as! UIScrollView
        let vc:PlayerViewController = (scrollView.delegate) as! PlayerViewController
            //collectionView.superview.superview
        vc.selectedMusicItem = selectedItem
        if mode == Mode.Player {
            vc.performSegue(withIdentifier: "Play", sender: self)
        } else {
            vc.performSegue(withIdentifier: "Edit", sender: self)
        }
        
        //var cell : UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        //cell.backgroundColor = UIColor.magentaColor()
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if mode == Mode.Edit {
            if gesture.state != .ended {
                return
            }
            let p = gesture.location(in: self.collectionView)
        
            if let indexPath = self.collectionView?.indexPathForItem(at: p) {
            // get the cell at indexPath (the one you long pressed)
            //let cell = self.collectionView.cellForItemAtIndexPath(indexPath)
            
                //parentViewController.deleteButton.isHidden = false
                parentViewController.helpButton.setTitle("Delete", for: UIControlState.normal)
                parentViewController.cellToBeDeleted = indexPath
                parentViewController.dataSourceToBeUpdated = self
                // do stuff with the cell
            } else {
                print("couldn't find index path")
            }
        }
    }

    func deleteButtonTapped() {
        if let cellToBeDeleted = parentViewController.cellToBeDeleted {
            //collectionView.deleteItems(at: [cellToBeDeleted])
            MusicItem.delete(musicItem: musicItems[page*6+cellToBeDeleted.row]) //TODO
            musicItems.remove(at: page*6+cellToBeDeleted.row)
            //itemsCount = itemsCount - 1
            //collectionView?.deleteItems(at: [cellToBeDeleted])
            //collectionView?.reloadData()
            
            //saveMusicItems() //TODO handle deletion with core data
            
            
            //musicItems.remove(at: page*6+cellToBeDeleted.row)
            //saveMusicItems() //TODO handle deletion with core data
            
            
            //collectionView.reloadData()
            //parentViewController.deleteButton.isHidden = true
            parentViewController.helpButton.setTitle("Help", for: UIControlState.normal)
        }
        
        
    }

    
}
