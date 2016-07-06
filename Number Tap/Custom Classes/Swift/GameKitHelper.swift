//
//  GameKitHelper.swift
//  Number Tap
//
//  Created by jesse on 27/03/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import GameKit

public class GameKitHelper : NSObject, GKGameCenterControllerDelegate {
    
    class var sharedGameKitHelper: GameKitHelper {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: GameKitHelper? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = GameKitHelper()
        }
        return Static.instance!
    }
    
    public var achievements = [String: GKAchievement]()
    public var gcEnabled = false
    public var gcDefaultLeaderBoard = ""
    
    private var timer = NSTimer()
    
    public var gcVC: GKGameCenterViewController!
    
    public func authenticateLocalPlayer(viewController: UIViewController) {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                viewController.presentViewController(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                NSUserDefaults.standardUserDefaults().setBool(self.gcEnabled, forKey: "gcEnabled")
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.checkIfAchivement), userInfo: nil, repeats: true)
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
    
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                NSUserDefaults.standardUserDefaults().setBool(self.gcEnabled, forKey: "gcEnabled")
                FTLogging().FTLog("Local player could not be authenticated, disabling game center")
                FTLogging().FTLog(error)
            }
            
        }
        
    }
    
    func checkIfAchivement() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let score = defaults.integerForKey("highScore")
        
        if score == 100 || score < 100 {
           reportAchievementIdentifier(k.GameCenter.Achivements.Points100, percent: 100.0)
        }
        
        else if score == 500 || score < 500 {
           reportAchievementIdentifier(k.GameCenter.Achivements.Points500, percent: 100.0)
        }
        
        else if score == 1000 || score < 1000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points1k, percent: 100.0)
        }
        
        else if score == 10000 || score < 10000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points10k, percent: 100.0)
        }
        
        else if score == 50000 || score < 50000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points50k, percent: 100.0)
        }
        
        else if score == 100000 || score < 10000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points100k, percent: 100.0)
        }
        
        else if score == 500000 || score < 500000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points500k, percent: 100.0)
        }
        
        else if score == 1000000 || score < 100000 {
            reportAchievementIdentifier(k.GameCenter.Achivements.Points1M, percent: 100.0)
        }

    }
    
    func showGameCenter(viewController: UIViewController, viewState: GKGameCenterViewControllerState) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let gc = defaults.boolForKey("gcEnabled")
        
        if gc == true {
            gcVC = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            gcVC.viewState = viewState
            
            viewController.presentViewController(gcVC, animated: true, completion: {
                
                
            })
        } else {
            let alert = UIAlertController(title: "Game Center Unavaliable", message: "Game Center is diabled", preferredStyle: .Alert) // 1
            let firstAction = UIAlertAction(title: "Ok", style: .Default) { (alert: UIAlertAction!) -> Void in
                
                NSLog("You pressed button one")
                
            }
            
            alert.addAction(firstAction)
            viewController.presentViewController(alert, animated: true, completion:nil) // 6

        }

    }
    
    public func reportAchievementIdentifier(identifier: String, percent: Double) {
        let achievement = GKAchievement(identifier: identifier)
        
        if !achievementIsCompleted(identifier) {
            achievement.percentComplete = percent
            achievement.showsCompletionBanner = true
            
            GKAchievement.reportAchievements([achievement]) { (error) -> Void in
                guard error == nil else {
                    print("Error in reporting achievements: \(error)")
                    return
                }
            }
        }
    }
    
    /**
     Loads all achievements into memory
     
     :param: completion An optional completion block that fires after all achievements have been retrieved
     */
    public func loadAllAchivements(completion: (() -> Void)? = nil) {
        GKAchievement.loadAchievementsWithCompletionHandler { (achievements, error) -> Void in
            guard error == nil, let achievements = achievements else {
                print("Error in loading achievements: \(error)")
                return
            }
            
            for achievement in achievements {
                if let id = achievement.identifier {
                    self.achievements[id] = achievement
                }
            }
            
            completion?()
        }
    }
    
    /**
     Checks if an achievement in allPossibleAchievements is already 100% completed
     
     :param: identifier A string that matches the identifier string used to create an achievement in iTunes Connect.
     */
    public func achievementIsCompleted(identifier: String) -> Bool{
        if let achievement = achievements[identifier] {
            return achievement.percentComplete == 100
        }
        
        return false
    }
    
    /**
     Resets all achievements that have been reported to GameKit.
     */
    public func resetAllAchievements() {
        GKAchievement.resetAchievementsWithCompletionHandler { (error) -> Void in
            guard error == nil else {
                print("Error resetting achievements: \(error)")
                return
            }
        }
    }
    
    /**
     Reports a high score eligible for placement on a leaderboard to GameKit.
     
     :param: identifier A string that matches the identifier string used to create a leaderboard in iTunes Connect.
     :param: score The score earned by the user.
     */
    public func reportLeaderboardIdentifier(identifier: String, score: Int) {
        let scoreObject = GKScore(leaderboardIdentifier: identifier)
        scoreObject.value = Int64(score)
        GKScore.reportScores([scoreObject]) { (error) -> Void in
            guard error == nil else {
                print("Error in reporting leaderboard scores: \(error)")
                return
            }
        }
    }
    
    
    // MARK: GKGameCenterControllerDelegate
    
    public func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
