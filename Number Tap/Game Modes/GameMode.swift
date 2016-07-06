//
//  GameMode.swift
//  Number Tap
//
//  Created by jesse on 05/07/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import StoreKit
import GameKit
import StoreKit
import ReplayKit
import MBProgressHUD

class BaseScene : SKScene {
    let background = SKSpriteNode(imageNamed: "background")
    var avaliableNumbers = [Int]()
    var products = [SKProduct]()
    var continueArray = [SKNode]()
    var topArray = [SKNode]()
    var timerArray = [NSTimer]()
    
    var currentMode: gameMode!
    
    let countdown = CountdownNode(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(0, 0))
    var countdownTimer = NSTimer()
    
    let starVideo = SKSpriteNode(imageNamed: "starVideo")
    let records = SKSpriteNode(imageNamed: "records")
    var scoreLabel = AnimatedScoreLabel(text: "", score: 0, size: 25, color: k.flatColors.red)
    var numbersTap = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    var tapOnLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let numberLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let circularTimer = ProgressNode()
    
    var number : Int = 0

     init(size: CGSize, mode: gameMode) {
        super.init(size: size)
        
        currentMode = mode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.productPurchased), name: IAPHelperProductPurchasedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(productCancelled), name: "cancelled", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.rewardUser(_:)), name: "videoRewarded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.counterComplete), name: "counter", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.setPaused), name: "pauseGame", object: nil)
        
        products = []
        Products.store.requestProductsWithCompletionHandler { (success, products) in
            if success {
                self.products = products
            }
        }
        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("hasRemovedAds") as? Bool {
            FTLogging().FTLog("all ads are gone")
            
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("hideBanner", object: nil)
        }
        
        size = CGSizeMake(640, 960)
        backgroundColor = UIColor(red: 40, green: 40, blue: 40, alpha: 1)
        scaleMode = .AspectFill
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.size = self.size
        background.zPosition = -10
        addChild(background)
        
    }
    
    internal func startCountDown() {
        countdown.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        countdown.zPosition = 10
        addChild(countdown)
        
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.countdownCheck), userInfo: nil, repeats: true)
        timerArray.append(countdownTimer)
        
        let dbackground = SKSpriteNode(imageNamed: "background")
        dbackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        dbackground.size = self.size
        dbackground.alpha = 0.8
        dbackground.name = "bg"
        dbackground.zPosition = 9
        addChild(dbackground)
        
    }
    
    func countdownCheck() {
        
        countdown.counterUpdate()
    }
    
    func setup() {
        let timerSpace = SKTexture(imageNamed: "timerSpace")
        circularTimer.position = CGPointMake(470, 850)
        circularTimer.radius = timerSpace.size().width / 2
        circularTimer.width = 8.0
        circularTimer.zPosition = 2
        circularTimer.color = UIColor(rgba: "#e74c3c")
        circularTimer.backgroundColor = UIColor(rgba: "#434343")
        addChild(circularTimer)
        
        scoreLabel.position = CGPointMake(circularTimer.position.x - 320, circularTimer.position.y)
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.fontColor = UIColor(rgba: "#e74c3c")
        addChild(scoreLabel)
        
        numbersTap.text = "NUMBERS TAPPED"
        numbersTap.position = CGPointMake(scoreLabel.position.x + 15, scoreLabel.position.y)
        numbersTap.horizontalAlignmentMode = .Left
        numbersTap.fontColor = UIColor.whiteColor()
        numbersTap.fontSize = 25
        numbersTap.zPosition = scoreLabel.zPosition
        addChild(numbersTap)
        
        starVideo.position = CGPointMake(scoreLabel.position.x + 10, scoreLabel.position.y - 32)
        starVideo.name = "starVideo"
        starVideo.zPosition = 2
        addChild(starVideo)
        
        records.position = CGPointMake(starVideo.position.x + 65, starVideo.position.y)
        records.name = "records"
        records.zPosition = 2
        addChild(records)
        
        self.tapOnLabel.fontColor = UIColor.whiteColor()
        self.tapOnLabel.fontSize = 30
        self.tapOnLabel.text = "TAP NUMBER:"
        self.tapOnLabel.horizontalAlignmentMode = .Center
        self.tapOnLabel.verticalAlignmentMode = .Center
        self.tapOnLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 25, -90)
        self.addChild(self.tapOnLabel)
        
        self.number = self.randomNumber()
        
        self.numberLabel.fontColor = UIColor(rgba: "#e74c3c")
        self.numberLabel.fontSize = 38
        self.numberLabel.text = String(self.number)
        self.numberLabel.horizontalAlignmentMode = .Center
        self.numberLabel.verticalAlignmentMode = .Center
        self.numberLabel.position = CGPointMake(self.tapOnLabel.position.x + 130, -90)
        self.addChild(self.numberLabel)
        
        self.tapOnLabel.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        self.numberLabel.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0), completion: {
        })
        
        randomWord()
    }

    func randomWord() {
        
        let getRandom = randomSequenceGenerator(1, max: 99)
        for _ in 1...99 {
            avaliableNumbers.append(getRandom());
            
        }
        
    }
    
    func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.count == 0 {
                numbers = Array(min ... max)
            }
            
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.removeAtIndex(index)
        }
    }
    
    func randomNumber() -> Int {
        
        if avaliableNumbers.count > 0 {
            
            var randNum = 0
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(avaliableNumbers.count)))
            
            // your random number
            randNum = avaliableNumbers[arrayKey]
            
            // make sure the number isnt repeated
            avaliableNumbers.removeAtIndex(arrayKey)
            
            return randNum;
            
        } else {
            resetScene()
            
            
            var randNum = 0
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(avaliableNumbers.count)))
            
            // your random number
            randNum = avaliableNumbers[arrayKey]
            
            // make sure the number isnt repeated
            avaliableNumbers.removeAtIndex(arrayKey)
            
            return randNum;
            
        }
        
    }

    func resetScene() {
        
        avaliableNumbers.removeAll()
        randomWord()
        number = randomNumber()
        numberLabel.text = "\(number)"
        
    }
    
    @objc private func productCancelled() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
}