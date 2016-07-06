//
//  AppDelegate.swift
//  Number Tap
//
//  Created by jesse on 12/03/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import UIKit
import Appirater
import Fabric
import Crashlytics
import iAd
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ChartboostDelegate, SupersonicRVDelegate {

    var window: UIWindow?
    var type: NotificationType?
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Appirater.setAppId("1097322101")
        Appirater.setDaysUntilPrompt(7)
        Appirater.setUsesUntilPrompt(5)
        Appirater.setSignificantEventsUntilPrompt(-1)
        Appirater.setTimeBeforeReminding(2)
        Appirater.setDebug(false)
        Appirater.appLaunched(true)
        
        for lNotification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if lNotification.alertBody == notificationMessage(.ComeBack) {
                UIApplication.sharedApplication().cancelLocalNotification(lNotification)
                break
            }
        }
        
        UAirship.takeOff()
        
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        
        FTLogging().setup(true)
        
        
        if ((NSUserDefaults.standardUserDefaults().boolForKey("adsGone") == true) != nil){
            Chartboost.startWithAppId(k.keys.cbAppId, appSignature: k.keys.cbAppSignature, delegate: self)
            Chartboost.setAutoCacheAds(true)
            Chartboost.setShouldPrefetchVideoContent(true)
            Chartboost.setShouldDisplayLoadingViewForMoreApps(true)
            
            Supersonic.sharedInstance()
            SupersonicIntegrationHelper.validateIntegration()
            
            var idfv = NSUUID().UUIDString
            Supersonic.sharedInstance().setRVDelegate(self)
            Supersonic.sharedInstance().initRVWithAppKey("4d9a08fd", withUserId: idfv)
            
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "videoSave")
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        for lNotification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if lNotification.alertBody == notificationMessage(.ComeBack) {
                UIApplication.sharedApplication().cancelLocalNotification(lNotification)
                break
            }
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.Year.union(NSCalendarUnit.Month).union(NSCalendarUnit.Day),fromDate: date)
        
        components.hour = 18
        components.minute = 30
        components.second = 00
        
        let tempDate = calendar.dateFromComponents(components)!
        let comps = NSDateComponents()
        comps.day = 2
        let fireDateOfNotification = calendar.dateByAddingComponents(comps, toDate: tempDate, options:[])
        
        scheduleNotificationWith(message: notificationMessage(.ComeBack)!, badgeNumber: 1, fireDate: fireDateOfNotification!)
        
        NSNotificationCenter.defaultCenter().postNotificationName("pauseGame", object: nil)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        for key in Array(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys) {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }

    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //MARK: Supersonic ADS :: RVDelegate
    func supersonicRVInitSuccess() {
        FTLogging().FTLog("Initialised rewarded video")
    }
    
    func supersonicRVInitFailedWithError(error: NSError!) {
        FTLogging().FTLog("Rewarded video init failed with error \(error.localizedDescription)")
    }
    
    func supersonicRVAdAvailabilityChanged(hasAvailableAds: Bool) {
        FTLogging().FTLog("Avaliability changed")
    }
    
    func supersonicRVAdRewarded(placementInfo: SupersonicPlacementInfo!) {
        FTLogging().FTLog("Ad Rewarded!")
        NSNotificationCenter.defaultCenter().postNotificationName("videoRewarded", object: nil, userInfo: ["rewardAmount" : placementInfo.rewardAmount,
             "rewardName"   : placementInfo.rewardName])
    }
    
    func supersonicRVAdOpened() {
        FTLogging().FTLog("Ad Opened")
        NSNotificationCenter.defaultCenter().postNotificationName("videoOpened", object: nil)
    }
    
    func supersonicRVAdClosed() {
        FTLogging().FTLog("Ad closed")
        NSNotificationCenter.defaultCenter().postNotificationName("videoClosed", object: nil)
    }
    
    func supersonicRVAdStarted() {
        FTLogging().FTLog("Ad Started")
    }
    
    func supersonicRVAdEnded() {
        FTLogging().FTLog("Ad Ended")
    }
    func supersonicRVAdFailedWithError(error: NSError!) {
        FTLogging().FTLog("Rewarded video  failed with error \(error.localizedDescription)")

    }
    
    //MARK: Notification
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        if notification.alertBody == notificationMessage(.ComeBack) {
            let pointsAdded = 20
            let defaults = NSUserDefaults.standardUserDefaults()
            let oldScore = defaults.integerForKey("score")
            let newScore = oldScore + pointsAdded
            
            defaults.setInteger(newScore, forKey: "score")
            
        }
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if shortcutItem.type == "com.flatboxstudio.numbertap.open-endless" {
            NSNotificationCenter.defaultCenter().postNotificationName("sceneSet", object: nil)
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        UAirship.push().appRegisteredForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UAirship.push().appRegisteredUserNotificationSettings()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        UAirship.push().appReceivedRemoteNotification(userInfo, applicationState: application.applicationState)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        UAirship.push().appReceivedRemoteNotification(userInfo,
                                                      applicationState:application.applicationState,
                                                      fetchCompletionHandler:completionHandler)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        UAirship.push().appReceivedActionWithIdentifier(identifier!,
                                                        notification: userInfo,
                                                        applicationState: application.applicationState,
                                                        completionHandler: completionHandler)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        UAirship.push().appReceivedActionWithIdentifier(identifier!,
                                                        notification: userInfo,
                                                        responseInfo: responseInfo,
                                                        applicationState: application.applicationState,
                                                        completionHandler: completionHandler)
    }
    
    func scheduleNotificationWith(message message: String, badgeNumber: Int, fireDate date: NSDate) {
        // 1 Create empty notification
        let localNotification = UILocalNotification()
        
        // 2 Set properties of your notification
        localNotification.alertBody = message
        localNotification.fireDate = date
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = badgeNumber
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        if type == .ComeBack {
        localNotification.userInfo = ["information" : "teset"]
        }
        
        // 3 Schedule the notification
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
    func notificationMessage(type: NotificationType) -> String? {
        switch type {
        case .ComeBack:
            type == .ComeBack
            return "Come back! It's been a while... How about a couple of points?"
        case .Waited:
            type == .Waited
            return "Your time has been set back and it's time to play!"
        }
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
            backgroundMusicPlayer.volume = 0.7
        } catch let error as NSError {
            print(error.description)
        }
    }

}

