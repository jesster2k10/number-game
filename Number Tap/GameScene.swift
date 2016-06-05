//
//  GameScene.swift
//  Number Tap
//
//  Created by jesse on 12/03/2016.
//  Copyright (c) 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit
import GameKit
import StoreKit
import ReplayKit

class GameScene: SKScene, RPScreenRecorderDelegate {
    var array = [Int]()
    var products = [SKProduct]()
    
    var topArray = [SKNode]()
    
    var number = 0
    var score : Int = 0
    var numbersTapped : Int = 0
    var hasRun = 0
    var timeToMemorize : Int32 = 60
    
    var counterHasFinished = false
    var popUpIsInScene = false
    var isRecording = false
    
    var currentMode: gameMode!

    var swiftTimer = NSTimer()
    var swiftCounter = 60
    
    let time = 30
    let currentTime = 30
    
    var countdownTime = 45.0
    
    var timeLabel = SKLabelNode()
    var scoreLabel = AnimatedScoreLabel(text: "Score", score: 0, size: 25, color: UIColor(rgba: "#e74c3c"))
    var numbersTap = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    
    var tapOnLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let numberLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    
    let progressBar = TCProgressBarNode(size: CGSizeMake(150,32.0),
                                        backgroundColor: UIColor.darkGrayColor(),
                                        fillColor: UIColor.redColor(),
                                        borderColor: UIColor.lightGrayColor(),
                                        borderWidth: 2.0,
                                        cornerRadius: 4.0)
    
    let circularTimer = ProgressNode()
    var gameTimer = NSTimer()
    
    var shortestTimer = NSTimer()
    var shortestTimeCounter = 0
    
    var longestTimer = NSTimer()
    var longestTimeCounter = 0
    
    var gameCounter: CGFloat = 0.0
    var pro : CGFloat = 0.0
    var hasGameEnded = false
    
    var progressTimer = NSTimer()
    
    let background = SKSpriteNode(imageNamed: "background")
    let share = SKSpriteNode(imageNamed: "share")
    let removeAds = SKSpriteNode(imageNamed: "removeAllAds")
    let gameCenter =  SKSpriteNode(imageNamed: "gameCenter")
    let bestScore = SKSpriteNode(imageNamed: "best")
    let beginGame = SKSpriteNode(imageNamed: "beginGame")
    let home = SKSpriteNode(imageNamed: "home")
    let sound = SKSpriteNode(imageNamed: "sound")
    let info = SKSpriteNode(imageNamed: "info")
    
    let pause = SKSpriteNode(imageNamed: "pause")
    let replay = SKSpriteNode(imageNamed: "replay")
    let record = SKSpriteNode(imageNamed: "record")
    let homeButton = SKSpriteNode(imageNamed: "home")
    
    let countdown = CountdownNode(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(0, 0))
    var popUp : SKSpriteNode!
    var countdownTimer = NSTimer()
    var minuteTime = NSTimer()
    
    let numberBox1 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox2 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox3 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox4 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox5 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox6 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox7 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox8 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox9 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox10 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox11 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox12 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox13 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox14 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox15 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox16 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox17 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox18 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox19 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox20 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox21 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox22 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox23 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox24 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    
    var boxArray = [NumberBox]()
    var timerArray = [NSTimer]()
    
    lazy var priceFormatter: NSNumberFormatter = {
        let pf = NSNumberFormatter()
        pf.formatterBehavior = .Behavior10_4
        pf.numberStyle = .CurrencyStyle
        return pf
    }()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.productPurchased), name: IAPHelperProductPurchasedNotification, object: nil)
        
        products = []
        Products.store.requestProductsWithCompletionHandler { (success, products) in
            if success {
                self.products = products
            }
        }
        
        randomWord()
        
        size = CGSizeMake(640, 960)
        backgroundColor = UIColor(red: 40, green: 40, blue: 40, alpha: 1)
        scaleMode = .AspectFill
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.size = self.size
        background.zPosition = -10
        addChild(background)
        
        currentMode = .Endless
        initScene(currentMode, time: nil)
    }
    
    //MARK: Init Methods
    
    func setupScene (mode : gameMode) {
        score = 0
        swiftCounter = 0
        gameCounter = 30
        
        scoreLabel.text = ""
        
        numberBox1.position = CGPoint(x:170, y:700)
        numberBox1.indexs = array[0]
        self.addChild(numberBox1)
        
        numberBox2.indexs = array[1]
        numberBox2.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y)
        self.addChild(numberBox2)
        
        numberBox3.indexs = array[2]
        numberBox3.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y)
        self.addChild(numberBox3)
        
        numberBox4.indexs = array[3]
        numberBox4.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y)
        self.addChild(numberBox4)
        
        numberBox5.indexs = array[4]
        numberBox5.position = CGPoint(x:numberBox1.position.x, y:numberBox1.position.y - 100)
        self.addChild(numberBox5)
        
        numberBox6.indexs = array[5]
        numberBox6.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y - 100)
        self.addChild(numberBox6)
        
        numberBox7.indexs = array[6]
        numberBox7.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y - 100)
        self.addChild(numberBox7)
        
        numberBox8.indexs = array[7]
        numberBox8.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y - 100)
        self.addChild(numberBox8)
        
        numberBox9.indexs = array[8]
        numberBox9.position = CGPoint(x:numberBox1.position.x, y:numberBox1.position.y - 200)
        self.addChild(numberBox9)
        
        numberBox10.indexs = array[9]
        numberBox10.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y - 200)
        self.addChild(numberBox10)
        
        numberBox11.indexs = array[10]
        numberBox11.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y - 200)
        self.addChild(numberBox11)
        
        numberBox12.indexs = array[11]
        numberBox12.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y - 200)
        self.addChild(numberBox12)
        
        numberBox13.indexs = array[12]
        numberBox13.position = CGPoint(x:numberBox1.position.x, y:numberBox1.position.y - 300)
        self.addChild(numberBox13)
        
        numberBox14.indexs = array[13]
        numberBox14.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y - 300)
        self.addChild(numberBox14)
        
        numberBox15.indexs = array[14]
        numberBox15.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y - 300)
        self.addChild(numberBox15)
        
        numberBox16.indexs = array[15]
        numberBox16.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y - 300)
        self.addChild(numberBox16)
        
        numberBox17.indexs = array[16]
        numberBox17.position = CGPoint(x:numberBox1.position.x, y:numberBox1.position.y - 400)
        self.addChild(numberBox17)
        
        numberBox18.indexs = array[17]
        numberBox18.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y - 400)
        self.addChild(numberBox18)
        
        numberBox19.indexs = array[18]
        numberBox19.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y - 400)
        self.addChild(numberBox19)
        
        numberBox20.indexs = array[19]
        numberBox20.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y - 400)
        self.addChild(numberBox20)
        
        numberBox21.indexs = array[20]
        numberBox21.position = CGPoint(x:numberBox1.position.x, y:numberBox1.position.y - 500)
        self.addChild(numberBox21)
        
        numberBox22.indexs = array[21]
        numberBox22.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y - 500)
        self.addChild(numberBox22)
        
        numberBox23.indexs = array[22]
        numberBox23.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y - 500)
        self.addChild(numberBox23)
        
        numberBox24.indexs = array[23]
        numberBox24.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y - 500)
        self.addChild(numberBox24)
        
        self.tapOnLabel.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        self.numberLabel.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0), completion: {
        })
        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("hasRemovedAds") as? Bool {
             NSNotificationCenter.defaultCenter().postNotificationName("hideAds", object: nil)
        }
        
        if mode != .Memory {
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
            
            let dbackground = SKSpriteNode(imageNamed: "background")
            dbackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            dbackground.size = self.size
            dbackground.alpha = 0.8
            dbackground.name = "bg"
            dbackground.zPosition = 9
            addChild(dbackground)
            
            
            countdown.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            countdown.zPosition = 10
            addChild(countdown)
            
            countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.countdownCheck), userInfo: nil, repeats: true)
            timerArray.append(countdownTimer)
        }
        
        boxArray.append(numberBox1)
        boxArray.append(numberBox2)
        boxArray.append(numberBox3)
        boxArray.append(numberBox4)
        boxArray.append(numberBox5)
        boxArray.append(numberBox6)
        boxArray.append(numberBox7)
        boxArray.append(numberBox8)
        boxArray.append(numberBox9)
        boxArray.append(numberBox10)
        boxArray.append(numberBox11)
        boxArray.append(numberBox12)
        boxArray.append(numberBox13)
        boxArray.append(numberBox14)
        boxArray.append(numberBox15)
        boxArray.append(numberBox16)
        boxArray.append(numberBox17)
        boxArray.append(numberBox18)
        boxArray.append(numberBox19)
        boxArray.append(numberBox20)
        boxArray.append(numberBox21)
        boxArray.append(numberBox22)
        boxArray.append(numberBox23)
        boxArray.append(numberBox24)
    }
    
    func initScene(mode: gameMode, time: Int?) {
        
        if mode == .Timed {
            
            setupScene(mode)
            
            for box in  boxArray {
                box.scale()
            }
            
            currentMode = .Timed
            
            FTLogging().FTLog("\n current game mode is Times \n")
            
            let timerSpace = SKTexture(imageNamed: "timerSpace")
            self.circularTimer.position = CGPointMake(self.numberBox4.position.x, 850)
            self.circularTimer.zPosition = 8
            self.circularTimer.radius = timerSpace.size().width / 2
            self.circularTimer.width = 8.0
            self.circularTimer.zPosition = 2
            self.circularTimer.color = UIColor(rgba: "#e74c3c")
            self.circularTimer.backgroundColor = UIColor(rgba: "#434343")
            
            self.addChild(self.circularTimer)
            
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
            
            pause.position = CGPointMake(scoreLabel.position.x, scoreLabel.position.y - 32)
            pause.name = "pause"
            pause.zPosition = 2
            addChild(pause)
            
            homeButton.position = CGPointMake(pause.position.x + 45, pause.position.y)
            homeButton.name = "homeButton"
            homeButton.zPosition = 2
            addChild(homeButton)
            
            replay.position = CGPointMake(homeButton.position.x + 45, homeButton.position.y)
            replay.name = "replay"
            replay.zPosition = 2
            addChild(replay)
            
            record.position = CGPointMake(replay.position.x + 45, replay.position.y)
            record.name = "record"
            record.zPosition = 2
            addChild(record)
            
        } else if mode == .Endless {
            
            setupScene(mode)
            
            currentMode = mode
            
            for box in  boxArray {
                box.scale()
            }
            
            FTLogging().FTLog("\n current game mode is Endless \n")
            
            let timerSpace = SKTexture(imageNamed: "timerSpace")
            self.circularTimer.position = CGPointMake(self.numberBox4.position.x, 850)
            self.circularTimer.zPosition = 8
            self.circularTimer.radius = timerSpace.size().width / 2
            self.circularTimer.width = 8.0
            self.circularTimer.zPosition = 2
            self.circularTimer.color = UIColor(rgba: "#e74c3c")
            self.circularTimer.backgroundColor = UIColor(rgba: "#434343")
            
            self.addChild(self.circularTimer)
            
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
            
            pause.position = CGPointMake(scoreLabel.position.x, scoreLabel.position.y - 32)
            pause.name = "pause"
            pause.zPosition = 2
            addChild(pause)
            
            homeButton.position = CGPointMake(pause.position.x + 45, pause.position.y)
            homeButton.name = "homeButton"
            homeButton.zPosition = 2
            addChild(homeButton)
            
            replay.position = CGPointMake(homeButton.position.x + 45, homeButton.position.y)
            replay.name = "replay"
            replay.zPosition = 2
            addChild(replay)
            
            record.position = CGPointMake(replay.position.x + 45, replay.position.y)
            record.name = "record"
            record.zPosition = 2
            addChild(record)

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
    
    func randomArray(array: [Int]) -> () -> Int {
        var numbers: [Int] = []
        return {
            if array.count == 0 {
                numbers = array
            }
            
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.removeAtIndex(index)
        }
    }
    
    func randomWord() {
        
        let getRandom = randomSequenceGenerator(1, max: 99)
        for _ in 1...24 {
            array.append(getRandom());
            
        }
        
    }
    
    func randomNumber() -> Int {
        
        if array.count > 0 {
            
            var randNum = 0
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(array.count)))
            
            // your random number
            randNum = array[arrayKey]
            
            // make sure the number isnt repeated
            array.removeAtIndex(arrayKey)
            
            return randNum;
            
        } else {
            resetScene()
            
            
            var randNum = 0
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(array.count)))
            
            // your random number
            randNum = array[arrayKey]
            
            // make sure the number isnt repeated
            array.removeAtIndex(arrayKey)
            
            return randNum;
            
        }
        
    }

    
    func countdownCheck() {
        
        countdown.counterUpdate()
    
        if NSUserDefaults.standardUserDefaults().boolForKey("init") == true {
            
            countdownTimer.invalidate()
            countdown.runAction(SKAction.fadeAlphaTo(0, duration: 1), completion: { 
                self.countdown.removeFromParent()
                self.childNodeWithName("bg")?.removeFromParent()
                
                if self.currentMode != .Memory {
                
                    self.circularTimer.countdown(45) { (Void) in
                        self.gameEnd()
                    }
                    
                    //self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.gameTimerCheck), userInfo: nil, repeats: true)
                    self.timerArray.append(self.gameTimer)
                    
                }
                
                self.counterHasFinished = true
                
                self.shortestTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.updateCurrentGameTime), userInfo: nil, repeats: true)
                self.timerArray.append(self.shortestTimer)
                
                self.longestTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.updateCurrentGameTime), userInfo: nil, repeats: true)
                self.timerArray.append(self.longestTimer)
            })
            
        }
 
    }
    
    func updateCurrentGameTime() {
        shortestTimeCounter += 1
        longestTimeCounter += 1
    }
    
    func secondsToHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //MARK: Scoring Methods/Scene Methods
    
    func setPaused(paused isPaused: Bool) {
        
    }
    
    func gameEnd() {
        
        circularTimer.stopCountdown()
        
        longestTimer.invalidate()
        
        GameKitHelper.sharedGameKitHelper.reportLeaderboardIdentifier(k.GameCenter.Leaderboard.TopScorers, score: numbersTapped)
        GameKitHelper.sharedGameKitHelper.reportLeaderboardIdentifier(k.GameCenter.Leaderboard.LongestRound, score: longestTimeCounter)
        GameKitHelper.sharedGameKitHelper.checkIfAchivement()
        
        /*if launchedBefore  {
            FTLogging().FTLog("Not first launch.")
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(score, forKey: "score")
        }
        else {
            FTLogging().FTLog("First launch, setting NSUserDefault.")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let oldScore = defaults.integerForKey("score")
            let newScore = oldScore + score
            
            defaults.setInteger(newScore, forKey: "score")
        }*/
        
        let def = NSUserDefaults.standardUserDefaults()
        if let _ = def.objectForKey("hasRemovedAds") as? Bool {
            FTLogging().FTLog("all ads are gone")
            
        } else {
            
            let random = arc4random_uniform(8) + 1
            
            if random == 5 || random == 2 {
                AdColony.playVideoAdForZone(k.keys.ADZoneIDs[0], withDelegate: nil)
            }
        }
        
        if hasRun == 0 {
            
            hasGameEnded = true
        
            NSUserDefaults.standardUserDefaults().highScore = numbersTapped
            
            
            for box in boxArray {
                box.userInteractionEnabled = false
            }
            
            let dbackground = SKSpriteNode(imageNamed: "background")
            dbackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            dbackground.size = self.size
            dbackground.name = "whiteBG"
            dbackground.alpha = 0.8
            dbackground.zPosition = 3
            if self.children.contains(dbackground) {} else { addChild(dbackground) }
            
            bestScore.setScale(1.12)
            bestScore.name = "bestScore"
            bestScore.position = CGPointMake(CGRectGetMidX(self.frame) - 100, CGRectGetMidY(self.frame))
            bestScore.zPosition = 4
            bestScore.setScale(0)
            
            let bestScoreText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
            bestScoreText.text = String(NSUserDefaults.standardUserDefaults().highScore)
            bestScoreText.fontColor = UIColor.whiteColor()
            bestScoreText.fontSize = 42
            bestScoreText.zPosition = bestScore.zPosition + 1
            bestScoreText.horizontalAlignmentMode = .Center
            bestScoreText.verticalAlignmentMode = .Center
            bestScoreText.position.y = bestScore.size.height/2 - 28
            
            if bestScore.children.contains(bestScoreText) {} else { bestScore.addChild(bestScoreText) }
            
            if self.children.contains(bestScore) {} else { addChild(bestScore)
                bestScore.runAction(SKAction.scaleTo(1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            }
            
            gameCenter.name = "gameCenter"
            gameCenter.position = CGPointMake(bestScore.position.x + 180, bestScore.position.y)
            gameCenter.zPosition = 4
            if self.children.contains(gameCenter) {} else { addChild(gameCenter) }
            
            removeAds.name = "removeAds"
            removeAds.position = CGPointMake(gameCenter.position.x - 50, gameCenter.position.y + 140)
            removeAds.zPosition = 4
            removeAds.setScale(0.2)
            if self.children.contains(removeAds) {} else { addChild(removeAds) }
            
            removeAds.runAction(SKAction.scaleTo(1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            
            share.name = "share"
            share.position = CGPointMake(removeAds.position.x  - 20, removeAds.position.y - 270)
            share.zPosition = 4
            share.setScale(0.4)
            if self.children.contains(share) {} else { addChild(share) }
            
            share.runAction(SKAction.scaleTo(1, duration: 0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            
            beginGame.name = "beginGame"
            beginGame.position = CGPointMake(CGRectGetMidX(self.frame), -90)
            beginGame.zPosition = 4
            if self.children.contains(beginGame) {} else { addChild(beginGame) }
            
            beginGame.runAction(SKAction.moveToY(90, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            
            var arr = [SKSpriteNode]()
            
            home.name = "home"
            home.position = CGPoint(x: CGRectGetMidX(self.frame) + 145, y: 150)
            home.zPosition = 7
            home.alpha = 1
            home.setScale(0)
            addChild(home)
            
            info.name = "home"
            info.position = CGPoint(x: home.position.x - 50, y: home.position.y)
            info.zPosition = 7
            info.alpha = 1
            info.setScale(0)
            addChild(info)
            
            sound.name = "home"
            sound.position = CGPoint(x: info.position.x - 50, y: home.position.y)
            sound.zPosition = 7
            sound.alpha = 1
            sound.setScale(0)
            addChild(sound)
            
            arr.append(home)
            arr.append(info)
            arr.append(sound)
            
            for item in arr {
                item.runAction(SKAction.scaleTo(1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            }
            
            if self.children.contains(home) {
                FTLogging().FTLog("hskjfldk;sjfkldsjf;lksdjfkldsjfgklsdjglk \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
            }
      
            let gameOverText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
            gameOverText.color = UIColor.whiteColor()
            gameOverText.horizontalAlignmentMode = .Center
            gameOverText.zPosition = 22
            gameOverText.text = "game over"
            gameOverText.name = "gameOver"
            gameOverText.fontSize = 55
            gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), removeAds.position.y + 1000)
            if self.childNodeWithName("gameOver") != nil {
                addChild(gameOverText)
            }
            
            gameOverText.runAction(SKAction.moveToY(removeAds.position.y + 140, duration: 1))
            
            hasRun = 1
        }
        if isRecording {
            stopRecording()
        }

    }
    
    func clearScene() {
        
        removeAds.runAction(SKAction.moveToY(-1000, duration: 2.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        bestScore.runAction(SKAction.moveToY(-1000, duration: 2.1, delay: 1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        beginGame.runAction(SKAction.moveToY(-1000, duration: 2.2, delay: 2, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        share.runAction(SKAction.moveToY(-1000, duration: 2.4, delay: 1.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        gameCenter.runAction(SKAction.moveToY(-1000, duration: 2, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)) {
            
            self.childNodeWithName("whiteBG")?.removeFromParent()
            self.childNodeWithName("gameOver")?.removeFromParent()
            self.childNodeWithName("gameOver")?.removeAllActions()
            self.childNodeWithName("gameOver")?.removeAllChildren()
            
            self.bestScore.removeFromParent()
            self.bestScore.removeAllActions()
            self.bestScore.removeAllChildren()
            
            self.gameCenter.removeFromParent()
            self.gameCenter.removeAllChildren()
            self.gameCenter.removeAllActions()
            
            self.removeAds.removeFromParent()
            self.removeAds.removeAllChildren()
            self.removeAds.removeAllActions()
            
            self.share.removeFromParent()
            self.share.removeAllChildren()
            self.share.removeAllActions()
            
            self.beginGame.removeFromParent()
            self.beginGame.removeAllChildren()
            self.beginGame.removeAllActions()
            
            self.home.removeAllActions()
            self.home.removeFromParent()
            self.home.removeAllChildren()
            
            self.info.removeFromParent()
            self.info.removeAllChildren()
            self.sound.removeFromParent()
            self.sound.removeAllActions()
            
            for box in self.boxArray {
                box.paused = false
            }
            
            self.hasGameEnded = false
            
            self.resetScene()

        }
        
    }
    
    func resetScene() {
        
        shortestTimer.invalidate()
        GameKitHelper.sharedGameKitHelper.reportLeaderboardIdentifier(k.GameCenter.Leaderboard.ShortestTimes, score: shortestTimeCounter)
        
        array.removeAll()
        randomWord()
        
        hasRun = 0
        
        numberBox1.indexs = array[0]
        numberBox2.indexs = array[1]
        numberBox3.indexs = array[2]
        numberBox4.indexs = array[3]
        numberBox5.indexs = array[4]
        numberBox6.indexs = array[5]
        numberBox7.indexs = array[6]
        numberBox8.indexs = array[7]
        numberBox9.indexs = array[8]
        numberBox10.indexs = array[9]
        numberBox11.indexs = array[10]
        numberBox12.indexs = array[11]
        numberBox13.indexs = array[12]
        numberBox14.indexs = array[13]
        numberBox15.indexs = array[14]
        numberBox16.indexs = array[15]
        numberBox17.indexs = array[16]
        numberBox18.indexs = array[17]
        numberBox19.indexs = array[18]
        numberBox20.indexs = array[19]
        numberBox21.indexs = array[20]
        numberBox22.indexs = array[21]
        numberBox23.indexs = array[22]
        numberBox24.indexs = array[23]
        
        for box in boxArray {
            box.update()
        }
        
        for numberBox in boxArray {
            numberBox.normal()
        }
        
        number = randomNumber()
        numberLabel.text = "\(number)"
        
        self.circularTimer.stopCountdown()
        let num = countdownTime - 5.0
        countdownTime = num
        self.circularTimer.countdown(countdownTime) { (Void) in
            self.gameEnd()
        }
        
    }
    
    func loose() {
        
        gameEnd()
    }
    
    func point() {
        
        number = randomNumber()
        numberLabel.text = String(number)
        
        timeLabel.removeAllActions()
      
        let randScore = arc4random_uniform(250)+50
        
        score += Int(randScore)
        numbersTapped += 1
        scoreLabel.score = Int32(numbersTapped)
       
        
        if currentMode == .Timed {
            let pro = 0.5
            self.circularTimer.progress = CGFloat(pro)
        }
    }
       //MARK: In App Puchases Methods
    func restoreTapped() {
        Products.store.restoreCompletedTransactions()
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
                FTLogging().FTLog("product purchased with id \(productIdentifier) & \(product.productIdentifier)")
                if productIdentifier == Products.RemoveAds {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(true, forKey: "hasRemovedAds")
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("areAdsGone", object: self)
                }
                break
            }
        }
    }
    
    //MARK: GameCenter Methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)

            handleTouchedPoint(location)
        }
    }
    
    func handleTouchedPoint(location: CGPoint) {
        
        let node = self.nodeAtPoint(location)
        
        if hasGameEnded {
            if gameCenter.containsPoint(location) {
                FTLogging().FTLog("game center")
                
                gameCenter.runAction(k.Sounds.blopAction1)
                
                let vC = self.view!.window?.rootViewController
                GameKitHelper.sharedGameKitHelper.showGameCenter(vC!, viewState: .Default)
            }
            
            if home.containsPoint(location) {
                FTLogging().FTLog("home")
                let homeScene = HomeScene()
                self.view?.presentScene(homeScene, transition: SKTransition.fadeWithColor(UIColor(rgba: "#434343"), duration: 2))
                
            };
            
            if sound.containsPoint(location) {
                FTLogging().FTLog("sound")
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

            };
            
            if info.containsPoint(location) {
                let vc = self.view?.window?.rootViewController
                let alert = UIAlertController(title: "How To Play", message: "Simply tap the tile with the number that's displayed at the bottom of the screen while avoid to run out of time! \r\nHow fast can you tap? \r\n\r\nHow long can you last? \r\n\r\nMade by Jesse Onolememen 2016 \r\nIcons Provided by FreePik/FlatIcon", preferredStyle: .Alert) // 1
                let firstAction = UIAlertAction(title: "Yeah I got it!", style: .Default) { (alert: UIAlertAction!) -> Void in
                    NSLog("You pressed button one")
                    
                } // 2
                let restorePurchases = UIAlertAction(title: "Restore Purchases", style: .Default, handler: { (UIAlertAction) in
                    self.restoreTapped()
                })
                
                alert.addAction(firstAction) // 4
                alert.addAction(restorePurchases)
                vc!.presentViewController(alert, animated: true, completion:nil) // 6
            }
            
            if share.containsPoint(location) {
                FTLogging().FTLog("share")
                
                share.runAction(k.Sounds.blopAction1)
                
                let textToShare = "I just tapped \(numbersTapped) tiles in a FREE game called 'Number Tap' that's made by a 13-YEAR-OLD! Download Today!"
                
                if let myWebsite = NSURL(string: "https://itunes.apple.com/us/app/number-tap!/id1097322101?ls=1&mt=8") {
                    let objectsToShare = [textToShare, myWebsite]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    //New Excluded Activities Code
                    activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList]
                    
                    let vC = self.view?.window?.rootViewController
                    vC!.presentViewController(activityVC, animated: true, completion: nil)
                    
                }
            }
            if removeAds.containsPoint(location) {
                FTLogging().FTLog("remove ads")
                removeAds.runAction(k.Sounds.blopAction1)
                purchaseProduct(0)
            }
            
            if beginGame.containsPoint(location) {
                FTLogging().FTLog("begin game")
                beginGame.runAction(k.Sounds.blopAction1)
                clearScene()
            }
            
        }
        
        if home.containsPoint(location) {
            FTLogging().FTLog("home")
            let homeScene = HomeScene()
            self.view?.presentScene(homeScene, transition: SKTransition.fadeWithColor(UIColor(rgba: "#434343"), duration: 2))
        };
        
        if pause.containsPoint(location) {
            FTLogging().FTLog("pause")
        };
        
        if record.containsPoint(location) {
            FTLogging().FTLog("record")
            startRecording()
        };
        
        if replay.containsPoint(location) {
            FTLogging().FTLog("replay")
            resetScene()
        };
        
        if node.name == "beginGameButton" {
           
            for box in boxArray {
                box.flip()
            }
            
            counterHasFinished = true
            
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

            
            let timerSpace = SKTexture(imageNamed: "timerSpace")
            self.circularTimer.position = CGPointMake(self.numberBox4.position.x, 850)
            self.circularTimer.zPosition = 8
            self.circularTimer.radius = timerSpace.size().width / 2
            self.circularTimer.width = 8.0
            self.circularTimer.zPosition = 2
            self.circularTimer.color = UIColor(rgba: "#e74c3c")
            self.circularTimer.backgroundColor = UIColor(rgba: "#434343")
            
            self.addChild(self.circularTimer)
            
            self.scoreLabel.position = CGPointMake(self.circularTimer.position.x - 320, self.circularTimer.position.y)
            self.scoreLabel.horizontalAlignmentMode = .Left
            self.scoreLabel.fontColor = UIColor(rgba: "#e74c3c")
            self.addChild(self.scoreLabel)
            
            self.numbersTap.text = "NUMBERS TAPPED"
            self.numbersTap.position = CGPointMake(self.scoreLabel.position.x + 15, self.scoreLabel.position.y)
            self.numbersTap.horizontalAlignmentMode = .Left
            self.numbersTap.fontColor = UIColor.whiteColor()
            self.numbersTap.fontSize = 25
            self.numbersTap.zPosition = self.scoreLabel.zPosition
            self.addChild(self.numbersTap)
            
            self.pause.position = CGPointMake(self.scoreLabel.position.x, self.scoreLabel.position.y - 32)
            self.pause.name = "pause"
            self.pause.zPosition = 2
            self.addChild(self.pause)
            
            self.homeButton.position = CGPointMake(self.pause.position.x + 45, self.pause.position.y)
            self.homeButton.name = "homeButton"
            self.homeButton.zPosition = 2
            self.addChild(self.homeButton)
            
            self.replay.position = CGPointMake(self.homeButton.position.x + 45, self.homeButton.position.y)
            self.replay.name = "replay"
            self.replay.zPosition = 2
            self.addChild(self.replay)
            
            self.record.position = CGPointMake(self.replay.position.x + 45, self.replay.position.y)
            self.record.name = "record"
            self.record.zPosition = 2
            self.addChild(self.record)
            
            self.topArray.append(self.circularTimer)
            self.topArray.append(self.scoreLabel)
            self.topArray.append(self.numbersTap)
            self.topArray.append(self.circularTimer)
            self.topArray.append(self.pause)
            self.topArray.append(self.homeButton)
            self.topArray.append(self.replay)
            self.topArray.append(self.record)
            
            
        }
        
        if hasRun == 0 && counterHasFinished {
            
            for box in boxArray {
                if box.containsPoint(location) {
                    playSound(fileName: k.Sounds.blop01, onSprite: box)
                    
                    if box.indexs == number {
                        FTLogging().FTLog ("point")
                        point()
                    } else {
                        FTLogging().FTLog("loose")
                        loose()
                    }
                    
                    if box.currentState != .used {
                        box.used()
                    }
                }
            }
            
      }

    }
    
    func stopRecording() {
        let vC = self.view?.window?.rootViewController
        RPScreenRecorder.sharedRecorder().stopRecordingWithHandler { (previewController: RPPreviewViewController?, error: NSError?) -> Void in
            if previewController != nil {
                let alertController = UIAlertController(title: "Recording", message: "Do you wish to discard or view your gameplay recording?", preferredStyle: .Alert)
                
                let discardAction = UIAlertAction(title: "Discard", style: .Default) { (action: UIAlertAction) in
                    RPScreenRecorder.sharedRecorder().discardRecordingWithHandler({ () -> Void in
                        // Executed once recording has successfully been discarded
                    })
                }
                
                let viewAction = UIAlertAction(title: "View", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    vC!.presentViewController(previewController!, animated: true, completion: nil)
                })
                
                alertController.addAction(discardAction)
                alertController.addAction(viewAction)
                
                vC!.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                // Handle error
            }
        }
    }
    
    func startRecording() {
        if RPScreenRecorder.sharedRecorder().available {
            RPScreenRecorder.sharedRecorder().startRecordingWithMicrophoneEnabled(true, handler: { (error: NSError?) -> Void in
                if error == nil { // Recording has started
                    self.isRecording = true
                } else {
                    // Handle error
                    self.isRecording = false
                }
            })
        } else {
            // Display UI for recording being unavailable
            self.isRecording = false
            let vc = self.view?.window?.rootViewController
            let alert = UIAlertController(title: "Recording Unavaliable", message: "Your device does not support recording!", preferredStyle: .Alert) // 1
            let firstAction = UIAlertAction(title: "Ok", style: .Default) { (alert: UIAlertAction!) -> Void in
                FTLogging().FTLog("You pressed button one")
           }
            
            alert.addAction(firstAction) // 4
            vc!.presentViewController(alert, animated: true, completion:nil) // 6
            
        }
    }
    
    func screenRecorder(screenRecorder: RPScreenRecorder, didStopRecordingWithError error: NSError, previewViewController: RPPreviewViewController?) {
        
    }
    
    func previewControllerDidFinish(previewController: RPPreviewViewController) {
        let vC = self.view?.window?.rootViewController
        vC!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func playSound(fileName sound: String, onSprite node: SKNode?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let isSoundEnabled = defaults.boolForKey("isSoundEnabled")
        
        let soundAction = SKAction.playSoundFileNamed(sound, waitForCompletion: false)
        
        if isSoundEnabled {
            node!.runAction(soundAction, completion: { 
                FTLogging().FTLog("\n Played sound with file named \r\n \(sound) \n")
            })
        } else {
            FTLogging().FTLog("\n Sound is disabled \n")
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
}

