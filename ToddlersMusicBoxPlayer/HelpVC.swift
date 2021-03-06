//
//  HelpVC.swift
//  Music Box Player
//
//  Created by Yelena Rubilova on 3/26/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import Foundation
import UIKit

class HelpVC: UIViewController, UIWebViewDelegate
{
    
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "index", withExtension: "html")
        //Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "help") as URL?
        let urlRequest = NSURLRequest(url: url!)
        
        self.webView.delegate = self
        self.webView.loadRequest(urlRequest as URLRequest)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
}
