//
//  Common.swift
//  ToddlersMusicBoxPlayer
//
//  Created by Yelena Rubilova on 2/27/17.
//  Copyright © 2017 Elena Rubilova. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
//import SwiftyBeaver
//let log = SwiftyBeaver.self
//let file = FileDestination()  // log to default swiftybeaver.log file


var maxItemsOnPage:Int = 6

    func disableButton(button: UIButton){
        button.isEnabled = false
        button.alpha = 0.5
        //button.backgroundColor = UIColor.lightGray
        //button.setTitleColor(UIColor.lightGray, for: UIControlState.disabled)
        
    }
    func enableButton(button: UIButton){
        button.isEnabled = true
        button.alpha = 1.0
        //button.backgroundColor = UIColor("Sky")
        //button.setTitleColor(UIColor.white, for: UIControlState.normal)
        
    }

func alert(message: String, title: String = "") -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    return alertController
}

/*func playSound(url : URL, completionHandler: @escaping (Void) -> Void ) {
        do {
        
        engine = AVAudioEngine()
        newPlayer = AVAudioPlayerNode()
        engine!.attach(newPlayer!)
        let mainMixer = engine!.mainMixerNode
        
        try engine!.start()
        
        engine!.connect(newPlayer!, to: mainMixer, format: mainMixer.outputFormat(forBus: 0))
        let soundFile = try AVAudioFile.init(forReading: url)
        let delay = 0 //getDelayAfterPlaying(url: url)
        print(delay)
            newPlayer!.scheduleFile(soundFile, at: nil, completionHandler: completionHandler) //self.performSegue(withIdentifier: "Test", sender: self.imageView)
        
        newPlayer!.play()
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    
    }*/

    func tryCatch<T>(block: () throws -> T) -> T? {
        do {
            return  try block()
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
//}
