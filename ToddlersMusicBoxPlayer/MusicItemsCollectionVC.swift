//
//  MusicItemsCollectionVC.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 1/30/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MusicItemsCollectionVC: UICollectionViewController {
    
    //var collectionViewLayout: CustomImageFlowLayout!

    @IBOutlet var deleteButton: UIButton!
    var cellToBeDeleted : IndexPath?
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let cellToBeDeleted = cellToBeDeleted {
            MusicItem.delete(musicItem: musicItems[cellToBeDeleted.row])
            musicItems.remove(at: cellToBeDeleted.row)
            //saveMusicItems() //TODO handle deletion with core data
            
            collectionView?.deleteItems(at: [cellToBeDeleted])
            deleteButton.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
        let layout = CVLayout()
        collectionView!.collectionViewLayout = layout
        //collectionView!.backgroundColor = .black
        // load music items
        
        
        let tapGestureRecognizer = UILongPressGestureRecognizer(target:self, action: #selector(MusicItemsCollectionVC.handleLongPress))
        collectionView?.isUserInteractionEnabled = true
        collectionView?.addGestureRecognizer(tapGestureRecognizer)
        
        deleteButton.isHidden = true
        
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
        return musicItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell*/
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        let musicItem = musicItems[indexPath.row]
        var image = musicItem.getFirstPhoto()
        //let images = musicItem.value(forKeyPath: "photos") as! NSSet//musicItem.photo
        if image == nil {
            image = UIImage(named:"pic1")! //TODO no image
        }
        cell.imageView.image = image
            
        
        
        return cell

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            print("Adding a new item.")
            
        case "PlayerMode":
            print("Switching to Player Mode.")
            
        case "ShowDetail":
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! MusicItemViewController
            guard let selectedMusicItemCell = sender as? ImageCollectionViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = collectionView!.indexPath(for: selectedMusicItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMusicItem = musicItems[indexPath.row]
            viewController.musicItem = selectedMusicItem
            
            /*guard let musicItemViewController = segue.destination as? MusicItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMusicItemCell = sender as? ImageCollectionViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = collectionView!.indexPath(for: selectedMusicItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMusicItem = musicItems[indexPath.row]
            musicItemViewController.musicItem = selectedMusicItem*/
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    /*private func saveMusicItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(musicItems, toFile: MusicItem.ArchiveURL.path)
        if isSuccessfulSave {
            print("Music items successfully saved")
        } else {
            print("Failed to save music items")
        }
    }*/
    
    /*private func loadMusicItems() -> [MusicItem]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: MusicItem.ArchiveURL.path) as? [MusicItem]
    }*/
    
    /*private func loadSampleMusicItems() {
        
        /*let photo1 = UIImage(named: "meal1")
         let photo2 = UIImage(named: "meal2")
         let photo3 = UIImage(named: "meal3")*/
        
        guard let musicItem1 = MusicItem(name: "No data in the table", photo: nil, sound: 0) else {
            fatalError("Unable to instantiate meal1")
        }
        
        /*guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
         fatalError("Unable to instantiate meal2")
         }
         
         guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
         fatalError("Unable to instantiate meal2")
         }*/
        
        musicItems += [musicItem1]
    }*/

    
    @IBAction func unwindToMusicItems(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MusicItemViewController, let musicItem = sourceViewController.musicItem {
            
            if collectionView?.indexPathsForSelectedItems?.count != 0 {
             // Update an existing musicItem.
                if let selectedIndexPath = collectionView?.indexPathsForSelectedItems {
                musicItems[selectedIndexPath.first!.row] = musicItem
                    collectionView?.reloadItems(at: [selectedIndexPath.first!]) }
             }
             else {
            // Add a new music item.
            
                let newIndexPath = IndexPath(row: musicItems.count-1, section: 0)
            
                //musicItems.append(musicItem)
                collectionView?.insertItems(at: [newIndexPath])
            }
            //saveMusicItems()
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


    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        let p = gesture.location(in: self.collectionView)
        
        if let indexPath = self.collectionView?.indexPathForItem(at: p) {
            // get the cell at indexPath (the one you long pressed)
            //let cell = self.collectionView.cellForItemAtIndexPath(indexPath)
            cellToBeDeleted = indexPath
            print("found the cell")
            deleteButton.isHidden = false
            // do stuff with the cell
        } else {
            print("couldn't find index path")
        }
    }
}

