//
//  HomeScene.swift
//  Number Tap
//
//  Created by jesse on 22/03/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit
import StoreKit

class HomeScene: SKScene {
    let background  = SKSpriteNode(imageNamed: "background")
    let play        = SKSpriteNode(imageNamed: "play")
    let numberTap   = SKSpriteNode(imageNamed: "number tap")
    let favourite   = SKSpriteNode(imageNamed: "favourite")
    let like        = SKSpriteNode(imageNamed: "like")
    let leaderboard = SKSpriteNode(imageNamed: "leaderboard")
    let removeAds   = SKSpriteNode(imageNamed: "remove-ads-long")
    let gameMode    = SKSpriteNode(imageNamed: "banner")
    let starOne     = SKSpriteNode(imageNamed: "star")
    let starTwo     = SKSpriteNode(imageNamed: "star")
    let sound       = SKSpriteNode(imageNamed: "sound")
    let info        = SKSpriteNode(imageNamed: "info")
    var products    = [SKProduct]()
    
    override func didMoveToView(view: SKView) {
        print("Home Scene did move to view")
        
        scaleMode = .AspectFill
        size = CGSizeMake(640, 960)
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.zPosition = -10
        background.size = self.size
        addChild(background)
        
        numberTap.position = CGPointMake(CGRectGetMidX(self.frame), 739) //324 322
        numberTap.zPosition = 2
        addChild(numberTap)
        
        info.position = CGPointMake(450, numberTap.position.y + 50)
        info.zPosition = 2
        addChild(info)
        
        sound.position = CGPointMake(info.position.x - 50, info.position.y)
        sound.zPosition = 2
        addChild(sound)
        
        play.position = CGPointMake(numberTap.position.x, 335)
        play.zPosition = 2
        addChild(play)
        
        favourite.position = CGPointMake(210, numberTap.position.y - 100)
        favourite.zPosition = 2
        addChild(favourite)
        
        leaderboard.position = CGPointMake(favourite.position.x + 110, favourite.position.y)
        leaderboard.zPosition = 2
        addChild(leaderboard)
        
        like.position = CGPointMake(leaderboard.position.x + 110, leaderboard.position.y)
        like.zPosition = 2
        addChild(like)
        
        removeAds.position = CGPointMake(numberTap.position.x, leaderboard.position.y - 100)
        removeAds.zPosition = 2
        let def = NSUserDefaults.standardUserDefaults()
        if let _ = def.objectForKey("hasRemovedAds") as? Bool { NSLog("all ads are gone") } else { addChild(removeAds) }
        
        gameMode.position = CGPointMake(play.position.x, play.position.y - 200)
        gameMode.zPosition = 2
        addChild(gameMode)
        
        starOne.position = CGPointMake(gameMode.position.x - 150, gameMode.position.y)
        starOne.zPosition = 5
        addChild(starOne)
        
        starTwo.position = CGPointMake(gameMode.position.x + 150, gameMode.position.y)
        starTwo.zPosition = 5
        addChild(starTwo)
        
        let increaseAction = SKAction.scaleTo(1.1, duration: 0.5)
        let decreaseAction = SKAction.scaleTo(1, duration: 0.5)
        let completeAction = SKAction.sequence([increaseAction, decreaseAction])
        let completeActions = SKAction.repeatActionForever(completeAction)
        
        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI*2), duration: 4)
        let rotateRepeat = SKAction.repeatActionForever(rotateAction)
        
        let rotateAction2 = SKAction.rotateByAngle(CGFloat(-M_PI*2), duration: 4)
        let rotateRepeat2 = SKAction.repeatActionForever(rotateAction2)
        
        let completeRepeatAction = SKAction.group([completeActions, rotateRepeat])
        
        starOne.runAction(rotateRepeat)
        starTwo.runAction(rotateRepeat2)
        
        let rotateAction1 = SKAction.rotateByAngle(CGFloat(-M_PI*2), duration: 4)
        let rotateRepeat1 = SKAction.repeatActionForever(rotateAction1)
        let completeRepeatAction1 = SKAction.group([completeActions, rotateRepeat1])
        
        favourite.runAction(completeRepeatAction)
        leaderboard.runAction(completeRepeatAction1)
        like.runAction(completeRepeatAction)
        
        removeAds.runAction(completeActions)
        gameMode.runAction(completeActions)
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "gameMode")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.productPurchased), name: IAPHelperProductPurchasedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setSceneEndless), name: "sceneSet", object: nil)
        
        products = []
        Products.store.requestProductsWithCompletionHandler { (success, products) in
            if success {
                self.products = products
            }
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedOnce") {
            
            if let _ = def.objectForKey("hasRemovedAds") as? Bool {
                NSLog("all ads are gone")
                
            } else {
                
                Chartboost.showInterstitial(CBLocationHomeScreen)
            }

        }
        
    }
    
    func setSceneEndless () {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "gameMode")
        let gameScene = GameScene()
        self.view?.presentScene(gameScene, transition: SKTransition.fadeWithColor(UIColor(rgba : "#434343"), duration: 1))
        starOne.runAction(k.Sounds.blopAction1)
    }
    
    //MARK: In App Puchases Methods
    func restoreTapped() {
        if Reachability.isConnectedToNetwork() {
            Products.store.restoreCompletedTransactions()
        } else {
            let vc = self.view?.window?.rootViewController
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Unable to purchase product. Please connect to the internet and try again", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (UIAlertAction) in
                NSLog("Alert")
            })
            
            alert.addAction(action)
            vc!.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func purchaseProduct(index: Int) {
        if Reachability.isConnectedToNetwork() {
            let product = products[index]
            Products.store.purchaseProduct(product)
        } else {
            let vc = self.view?.window?.rootViewController
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Unable to purchase product. Please connect to the internet and try again", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (UIAlertAction) in
                NSLog("Alert")
            })
            
            alert.addAction(action)
            vc!.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func productPurchased(notification: NSNotification) {
        let productIdentifier = notification.object as! String
        for (_, product) in products.enumerate() {
            if product.productIdentifier == productIdentifier {
                print("product purchased with id \(productIdentifier) & \(product.productIdentifier)")
                if productIdentifier == Products.RemoveAds {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(true, forKey: "hasRemovedAds")
                    removeAds.runAction(SKAction.fadeAlphaTo(0, duration: 2), completion: { 
                        self.removeAds.removeFromParent()
                    })
                }
                break
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if info.containsPoint(location) {
                let vc = self.view?.window?.rootViewController
                let alert = UIAlertController(title: "How To Play", message: "Simply tap the tile with the number that's displayed at the bottom of the screen while avoid to run out of time! \r\nHow fast can you tap? \r\nHow long can you last? \r\n\r\nMade by Jesse Onolememen 2016 \r\nIcons Provided by FreePik/FlatIcon", preferredStyle: .Alert) // 1
                let firstAction = UIAlertAction(title: "Yeah I got it!", style: .Default) { (alert: UIAlertAction!) -> Void in
                    NSLog("You pressed button one")
                    
                } // 2
                
                let restorePurchases = UIAlertAction(title: "Restore Purchases", style: .Default, handler: { (UIAlertAction) in
                    self.restoreTapped()
                })
                
                alert.addAction(firstAction) // 4
                alert.addAction(restorePurchases)
                vc!.presentViewController(alert, animated: true, completion:nil) // 6

            };
            
            if play.containsPoint(location) {
                print("play")
                play.runAction(k.Sounds.blopAction1)
                let gameScene = GameScene()
                self.view?.presentScene(gameScene, transition: SKTransition.fadeWithColor(UIColor(rgba: "#434343"), duration: 1))
            }
            
            if gameMode.containsPoint(location) {
                let vc = self.view?.window?.rootViewController
                let alert = UIAlertController(title: "Comming Soon!", message: "This feature is comming very soon...", preferredStyle: .Alert)
                let gotItAction = UIAlertAction(title: "Yeah, I got it", style: .Default, handler: { (UIAlertAction) in
                    
                })
                
                alert.addAction(gotItAction)
                vc!.presentViewController(alert, animated: true, completion: nil)
                
            }
            
            if like.containsPoint(location) {
                print("like")
                SocialNetwork.Facebook.openPage()
            }
            
            if favourite.containsPoint(location) {
                print("favourite")
                let iTunesBaseUrl = "number-tap!/id1097322101?ls=1&mt=8"
                let url = NSURL(string: "itms://itunes.apple.com/us/app/" + iTunesBaseUrl)
                
                if UIApplication.sharedApplication().canOpenURL(url!) {
                    UIApplication.sharedApplication().openURL(url!)
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(string: "https://facebook.com/831944953601016")!)
                }
            }
            
            if leaderboard.containsPoint(location) {
                print("leaderboard")
                GameKitHelper.sharedGameKitHelper.showGameCenter((view?.window?.rootViewController)!, viewState: .Leaderboards)
            }
            
            if removeAds.containsPoint(location) {
                print("remove ads")
                removeAds.runAction(k.Sounds.blopAction1)
                purchaseProduct(0)
            }
            
            if sound.containsPoint(location) {
                print("sound")
                sound.runAction(k.Sounds.blopAction1)
                var touchSound = 0
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                if touchSound == 0 {
                    touchSound += 1
                    if appDelegate.backgroundMusicPlayer.playing == true {
                        appDelegate.backgroundMusicPlayer.stop()
                    } else if touchSound == 1 {
                    touchSound -= 1
                    appDelegate.backgroundMusicPlayer.play()
                }
            }
        }
    }
        
   }
    
    func playSound(fileName sound: String, onSprite node: SKNode?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let isSoundEnabled = defaults.boolForKey("isSoundEnabled")
        
        let soundAction = SKAction.playSoundFileNamed(sound, waitForCompletion: false)
        
        if isSoundEnabled {
            node!.runAction(soundAction, completion: {
                print("\n Played sound with file named \r\n \(sound) \n")
            })
        } else {
            print("\n Sound is disabled \n")
        }
    }
    
}
