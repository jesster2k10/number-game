//
//  GameViewController.swift
//  Number Tap
//
//  Created by jesse on 12/03/2016.
//  Copyright (c) 2016 FlatBox Studio. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import iAd
import PermissionScope

class GameViewController: UIViewController, ADBannerViewDelegate {
    
    var gcEnabled = false
    var gcDefaultLeaderBoard = ""
    
    var timer = NSTimer()
    var bannerView: ADBannerView!
    let pscope = PermissionScope()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = HomeScene()
        
        // Configure the view.
        let skView = self.view as! SKView
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        
        GameKitHelper.sharedGameKitHelper.authenticateLocalPlayer(self)

        iAd()
        
        // Set up permissions
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                             message: "We use this to send you\r\nspam and love notes")
        pscope.addPermission(PhotosPermission(),
                             message: "We use this to save\r\ngameplay to your camera roll.")
        
        // Show dialog with callbacks
        pscope.show({ finished, results in
            print("got results \(results)")
            }, cancelled: { (results) -> Void in
                print("thing was cancelled")
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.checkIfAds), name: "areAdsGone", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.hideAds), name: "hideAds", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.showAds), name: "showAds", object: nil)
    }
    
    func hideAds (notification : NSNotification) {
        UIView.animateWithDuration(1.0) { () -> Void in
            
            self.bannerView.alpha = 0
        }

    }
    
    func showAds (notification : NSNotification) {
        UIView.animateWithDuration(1.0) { () -> Void in
            
            self.bannerView.alpha = 1
        }
        
    }
    
    
    func checkIfAds (notification: NSNotification) {
        if notification.name == "areAdsGone" {
            FTLogging().FTLog("Ads are gone")
            
            UIView.animateWithDuration(1.0) { () -> Void in
                
                self.bannerView.alpha = 0
                self.bannerView.removeFromSuperview()
            }
            
        }
    }
    
    func iAd() {
        
        let def = NSUserDefaults.standardUserDefaults()
        if let _ = def.objectForKey("hasRemovedAds") as? Bool {
            
            FTLogging().FTLog("all ads are gone")
        } else {
            
            bannerView = ADBannerView(adType: .Banner)
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            bannerView.delegate = self
            bannerView.hidden = true
            view.addSubview(bannerView)
            
            let viewsDictionary = ["bannerView": bannerView]
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
                
        }
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {

        FTLogging().FTLog("Ad Received")
        UIView.animateWithDuration(1.0) { () -> Void in
            
            self.bannerView.alpha = 1.0
            self.bannerView.hidden = false
        }
    

    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        UIView.animateWithDuration(1.0) { () -> Void in
            
            self.bannerView.alpha = 0
            self.bannerView.hidden = true
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
