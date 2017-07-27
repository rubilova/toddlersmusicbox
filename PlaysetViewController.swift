//
//  CreatePlaysetViewController.swift
//  Music Box Player
//
//  Created by Yelena Rubilova on 4/7/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NewPlaysetCell"

class CreatePlaysetViewController: UICollectionViewController {
    var playset: Playset = Playset.create()
    var selectedMusicItem: MusicItem?

    @IBAction func menuTapped(_ sender: Any) {
        revealViewController().revealToggle(sender)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        //TODO
    }
    
    @IBAction func unwindToPlayset(sender: UIStoryboardSegue) {
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playsets.append(playset)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(MusicItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let flowLayout = CVLayout()
        self.collectionView?.collectionViewLayout = flowLayout
        self.collectionView?.isScrollEnabled = false
        self.collectionView?.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if (playset.musicItems?.count)! < maxItemsOnPage {
            return (playset.musicItems?.count)! + 1
        } else {
            return maxItemsOnPage
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MusicItemCollectionViewCell
    
        let musicItem = getItem(index: indexPath.row)
        
        var image = musicItem.getFirstPhoto()
        //let images = musicItem.value(forKeyPath: "photos") as! NSSet//musicItem.photo
        if image == nil {
            image = UIImage(named:"addSound")! //TODO no image
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
    
    func getItem(index: Int) -> MusicItem {
        if index < (playset.musicItems?.count)! {
            return playset.musicItems!.array[index] as! MusicItem
        } else {
            let musicItem = MusicItem.create()
            //playset.addToMusicItems(musicItem)
            return musicItem
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let index = indexPath.row
        if index < (playset.musicItems?.count)! {
            let selectedItem = playset.musicItems![index] as! MusicItem
            self.selectedMusicItem = selectedItem
        }
        self.performSegue(withIdentifier: "Edit", sender: self)
        
        //var cell : UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        //cell.backgroundColor = UIColor.magentaColor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        
        case "Edit":
            
            
            //let viewController = MusicItemViewController()
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! MusicItemViewController
            viewController.playset = self.playset
            if selectedMusicItem != nil {
                viewController.musicItem = selectedMusicItem
                
            }
            //self.performSegue(withIdentifier: "Test", sender: self.imageView)
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }



    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
