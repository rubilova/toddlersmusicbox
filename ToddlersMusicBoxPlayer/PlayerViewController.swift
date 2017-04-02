//
//  PlayerViewController.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Elena Rubilova on 2/13/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import UIKit
import CoreData

var musicItems: Array<MusicItem> = []
enum Mode {case Player; case Edit}
var mode = Mode.Player
class PlayerViewController: UIViewController, UIScrollViewDelegate
{

    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var modeButton: UIButton!
    @IBOutlet var helpButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    
    var flowLayout : CVLayout!
    var bounds : CGRect!
    var pages: Int = 0
    var dataSources: [CVDataSource] = []
    var selectedMusicItem : MusicItem?
    var currentPage: Int = 0
    var scrollingLocked: Bool?
    var dataSourceToBeUpdated: CVDataSource?
    var cellToBeDeleted : IndexPath?
    
    @IBAction func modeButtonTapped(_ sender: Any) {
        // switching between player mode and edit mode
        if modeButton.title(for: UIControlState.normal)=="Edit" {
            mode = Mode.Edit
            modeButton.setTitle("Player", for:  UIControlState.normal)
            addButton.isHidden = false
        } else {
            mode = Mode.Player
            modeButton.setTitle("Edit", for:  UIControlState.normal)
            addButton.isHidden = true
        }
    }
    
    @IBAction func helpButtonTapped(_ sender: Any) {
    
        
        if helpButton.title(for: UIControlState.normal) == "About" {
            self.performSegue(withIdentifier: "Help", sender: self.helpButton)
        } else {
        dataSourceToBeUpdated?.deleteButtonTapped()
        //update pages starting from current page
        for i in currentPage...pages-1 {
            // update items count
            if i == pages-1 { //last page
                dataSources[i].itemsCount = itemsOnThePage(currentPage: i)
            }
            // remove page if it doesn't have any items
            if dataSources[i].itemsCount == 0 {
                    dataSources[i].collectionView.removeFromSuperview()
                    dataSources.remove(at: i)
                    pages = pages - 1
                    self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width*CGFloat(pages),height:self.scrollView.frame.size.height)
                    if (currentPage == pages){
                        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.size.width*CGFloat(pages-1), y: 0), animated: true)
                    }
                
            } else {
                dataSources[i].collectionView?.reloadData()
            }
        }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //cleanDeletedPhotos() //TODO
        scrollingLocked = false
        
        // load data
        if musicItems.count == 0 {
            loadMusicItems()
            if musicItems.count == 0 {
                loadSampleMusicItems()
            }
        }
        
        // add content to scrollview
        pages = Int(musicItems.count/maxItemsOnPage)
        if musicItems.count%maxItemsOnPage > 0 {
            pages = pages+1
        }
        self.scrollView.delegate = self;
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        bounds = self.scrollView.bounds
        for i in 0...pages-1 {
            createNewPage(page: i, itemsCount: itemsOnThePage(currentPage: i))
        }
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width*CGFloat(pages),height:self.scrollView.frame.size.height)
    }
    
    func createNewPage(page: Int, itemsCount: Int) -> CVDataSource {
        
        let x = bounds.width*CGFloat(page)
        let y = bounds.origin.y
        let width = bounds.width
        let height = bounds.height
        let flowLayout = CVLayout()
        let collectionViewElement = UICollectionView(frame: CGRect(x:x,y:y,width:width,height:height), collectionViewLayout: flowLayout)
        collectionViewElement.register(MusicItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell\(page)")
        let ds: CVDataSource = CVDataSource(page: page, cv: collectionViewElement, vc: self)
        ds.itemsCount = itemsCount
        dataSources.append(ds)
        collectionViewElement.delegate = dataSources[page]
        collectionViewElement.dataSource = dataSources[page]
        collectionViewElement.isScrollEnabled = false
        collectionViewElement.backgroundColor = UIColor.white
        self.scrollView.addSubview(collectionViewElement)
        return ds
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        // calculate current page
        if !scrollingLocked! {
            currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // disable scrolling on rotation for current page calculation
        super.viewWillTransition(to: size, with: coordinator)
        scrollingLocked = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // recalculate layout on rotation
        if self.scrollView.bounds.width != bounds.width {
            self.scrollView.bounds.origin.x = 0
            bounds = self.scrollView.bounds
            for i in 0...pages-1 {
                let x = bounds.origin.x + bounds.width*CGFloat(i)
                let y = bounds.origin.y
                let width = bounds.width
                let height = bounds.height
                let cv: UICollectionView = self.scrollView.subviews[i] as! UICollectionView
                cv.frame = CGRect(x:x,y:y,width:width,height:height)
                cv.collectionViewLayout.invalidateLayout()
            }
            self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width*CGFloat(pages),height:self.scrollView.frame.size.height)
            scrollView.contentOffset.x = self.scrollView.frame.size.width * CGFloat(currentPage)
            // enable scrolling after rotation for current page calculation
            scrollingLocked = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func itemsOnThePage(currentPage: Int) -> Int {
        
        let numberOfFullPages = Int(musicItems.count/maxItemsOnPage)
        if currentPage+1<=numberOfFullPages {
            return maxItemsOnPage
        } else {
            return musicItems.count%maxItemsOnPage
        }
    }
    
    private func cleanDeletedPhotos() {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.managedObjectContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Photo")
        
        //3
        var photos: Array<Photo> = []
        
        
        do {
            photos = try managedContext.fetch(fetchRequest as! NSFetchRequest<Photo>) //NSFetchRequestResult
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print(photos.count)
        var contextHasChanged = false
        if photos.count > 0 {
            for i in 0...photos.count-1 {
                if photos[i].musicItem == nil {
                    managedContext.delete(photos[i])
                    contextHasChanged = true
                }
            }
        }
        if contextHasChanged {
            do {
                try managedContext.save()
                //musicItems.append(musicItem) TODO: move deletion here
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    
    }

    private func loadMusicItems() {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.managedObjectContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "MusicItem")
        
        //3
        do {
            musicItems = try managedContext.fetch(fetchRequest as! NSFetchRequest<MusicItem>)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return
    }
    
    private func loadSampleMusicItems() {
        
        let image1 = UIImage(named: "pic1")
        let photo1 = PhotoAsset(photo: image1!, assetId: nil)
        MusicItem.save(name: "Itsy Bitsy Spider by Noelle and John", photos: [photo1], soundId: 0, sample: "ItsyBitsySpider")
        //musicItems.append(musicItem1)
        
        let image2 = UIImage(named: "pic2")
        let photo2 = PhotoAsset(photo: image2!, assetId: nil)
        MusicItem.save(name: "Freres Jacques by Noelle and John", photos: [photo2], soundId: 0, sample: "FreresJacques")
        //musicItems.append(musicItem2)
        
        let image3 = UIImage(named: "pic3")
        let photo3 = PhotoAsset(photo: image3!, assetId: nil)
        MusicItem.save(name: "Wheels on the bus by Noelle and John", photos: [photo3], soundId: 0, sample: "WheelsOnTheBus")
        
        let image4 = UIImage(named: "pic4")
        let photo4 = PhotoAsset(photo: image4!, assetId: nil)
        MusicItem.save(name: "Twinkle Twinkle Little Star by Noelle and John", photos: [photo4], soundId: 0, sample: "TwinkleTwinkleLittleStar")
        
        let image5 = UIImage(named: "pic5")
        let photo5 = PhotoAsset(photo: image5!, assetId: nil)
        MusicItem.save(name: "Bingo by Noelle and John", photos: [photo5], soundId: 0, sample: "BINGO")
        
        let image6 = UIImage(named: "pic6")
        let photo6 = PhotoAsset(photo: image6!, assetId: nil)
        MusicItem.save(name: "Alphabet song by Noelle and John", photos: [photo6], soundId: 0, sample: "AlphabetSong")
        /*
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        // 1
        let managedContext =
            appDelegate.managedObjectContext
        
        // 2
        let musicItemEntity =
            NSEntityDescription.entity(forEntityName: "MusicItem",
                                       in: managedContext)!
        let photoEntity =
            NSEntityDescription.entity(forEntityName: "Photo",
                                       in: managedContext)!
        
        let photo = NSManagedObject(entity: photoEntity,
                                        insertInto: managedContext)
        let image = UIImage(named: "pic1")
        let imageData = UIImagePNGRepresentation(image!)
        photo.setValue(imageData, forKey: "photo")
        
        let musicItem = MusicItem(entity: musicItemEntity,
                                        insertInto: managedContext)
        
        // 3
        musicItem.setValue("Itsy Bitsy Spider by Noelle and John", forKeyPath: "name")
        musicItem.setValue("ItsyBitsySpider", forKeyPath: "sample")
        musicItem.setValue(0, forKeyPath: "soundId")        
        musicItem.mutableSetValue(forKey: "photos").add(photo)
        // 4
        do {
            try managedContext.save()
            musicItems.append(musicItem)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }*/

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        /*case "EditMode":
            print("Switching to Edit Mode.")*/
        case "Help":
            print("Open help")
        case "Play":
            /*guard let viewController = segue.destination as? ViewController else {
             fatalError("Unexpected destination: \(segue.destination)")
             }*/
            
            /*guard let selectedMusicItemCell = sender as? MusicItemCollectionViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = collectionView!.indexPath(for: selectedMusicItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }*/
            
            //selectedMusicItem = musicItems[indexPath.row]
            
            // play sample if the item has it
            let navigationController = segue.destination as! UINavigationController
            
            let viewController = navigationController.topViewController as! ViewController
                viewController.musicItem = selectedMusicItem
            
            //viewController.photo
        case "AddItem":
            self.dataSourceToBeUpdated = dataSources[pages-1]
            // clear selected index paths
            if let selectedIndexPaths = self.dataSourceToBeUpdated?.collectionView?.indexPathsForSelectedItems {
                for indexPath in selectedIndexPaths {
                    self.dataSourceToBeUpdated?.collectionView.deselectItem(at: indexPath, animated: false)
                //[self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
                }
            }
            //print("Adding a new item.")
        case "Edit":
            self.dataSourceToBeUpdated = dataSources[currentPage] //TODO
        
            //let viewController = MusicItemViewController()
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! MusicItemViewController
            
            //.popToViewController(viewController, animated: true)
            viewController.musicItem = selectedMusicItem
            //self.performSegue(withIdentifier: "Test", sender: self.imageView)
        

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    @IBAction func unwindToPlayer(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController {
            
            print("Finished!")
        }
    }
    
    @IBAction func unwindToMusicItems(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MusicItemViewController, let musicItem = sourceViewController.musicItem {
            if let ds = dataSourceToBeUpdated {
            if ds.collectionView?.indexPathsForSelectedItems?.count != 0 {
                // Update an existing musicItem.
                if let selectedIndexPath = ds.collectionView?.indexPathsForSelectedItems {
                    musicItems[selectedIndexPath.first!.row] = musicItem
                    ds.collectionView?.reloadItems(at: [selectedIndexPath.first!]) }
            }
            else {
                // Add a new music item.
                if ds.itemsCount == 6 { // add new page
                    dataSourceToBeUpdated = createNewPage(page: pages, itemsCount: 1)
                    pages = pages+1
                    self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width*CGFloat(pages),height:self.scrollView.frame.size.height)
                    self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.size.width*CGFloat(pages-1), y: 0), animated: true)
                    /*let newIndexPath = IndexPath(row: (dataSourceToBeUpdated!.itemsCount), section: 0)
                    dataSourceToBeUpdated!.itemsCount = dataSourceToBeUpdated!.itemsCount + 1
                    dataSourceToBeUpdated!.collectionView?.insertItems(at: [newIndexPath])*/
                } else {
                    let newIndexPath = IndexPath(row: (ds.itemsCount)!, section: 0)
                    ds.itemsCount = ds.itemsCount + 1
                    //musicItems.append(musicItem)
                    ds.collectionView?.insertItems(at: [newIndexPath])
                    if (currentPage != pages-1) {
                        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.size.width*CGFloat(pages-1), y: 0), animated: true)
                    }
                }
                
            }
            //saveMusicItems()
            } else {
                //TODO: error
            }
        }
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
