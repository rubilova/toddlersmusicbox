//
//  HelpVC.swift
//  Music Box Player
//
//  Created by Yelena Rubilova on 3/26/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import Foundation
import UIKit

class HelpVC: UIViewController
{
    
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "index", withExtension: "html")
        //Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "help") as URL?
        let urlRequest = NSURLRequest(url: url!)
        self.webView.loadRequest(urlRequest as URLRequest)
    }
}
