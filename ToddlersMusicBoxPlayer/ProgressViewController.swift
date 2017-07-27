//
//  UploadViewController.swift
//  TotPlayer
//
//  Created by Yelena Rubilova on 5/13/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    //var playset: Playset?
    //var uploadOrDownload: (() -> Void)?
    
    @IBOutlet var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FirebaseConnect.percentComplete)
        let sharedInstance = FirebaseConnect.sharedInstance
        FirebaseConnect.updateProgress = {
            print(FirebaseConnect.percentComplete)
            self.progressView.setProgress(FirebaseConnect.percentComplete, animated: true)
            
            
        }
        FirebaseConnect.dismissIndicator = {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
}
