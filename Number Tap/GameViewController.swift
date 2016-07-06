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
import AVFoundation

class GameViewController: UIViewController, ADBannerViewDelegate {
    
    var gcEnabled = false
    var gcDefaultLeaderBoard = ""
    
    var timer = NSTimer()
    var bannerView: ADBannerView!
    let pscope = PermissionScope()
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showScene()
    }
    
    func showScene() {
        let fade = SKTransition.fadeWithColor(UIColor(rgba: "#434343"), duration: 6)
        let scene = Shoot(size: CGSizeMake(640, 960), mode: .Endless)
        
        // Configure the view.
        let skView = self.view as! SKView
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene, transition: fade)
        
        GameKitHelper.sharedGameKitHelper.authenticateLocalPlayer(self)
        
        if NSUserDefaults.isFirstLaunch() {
            // Set up permissions
            pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                                 message: "We use this to send you\r\nspam and love notes")
            pscope.addPermission(PhotosPermission(),
                                 message: "We use this to save\r\ngameplay to your camera roll.")
            pscope.show()
        }
        
        playBackgroundMusic(k.Sounds.blipBlop)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.playMusic), name: "playMusic", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.stopMusic), name: "stopMusic", object: nil)

    }
    
    func playBackgroundMusic(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func stopMusic() {
        FTLogging().FTLog("\n\n\n yea bitch \n\n\n")
        if backgroundMusicPlayer.playing == true {
            backgroundMusicPlayer.stop()
        }
    }
    
    func playMusic() {
        if backgroundMusicPlayer.playing == false {
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
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
