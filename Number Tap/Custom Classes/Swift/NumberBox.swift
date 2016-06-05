//
//  NumberBox.swift
//  Number Tap
//
//  Created by jesse on 12/03/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit

extension Array {
    func contain<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

enum boxStates : UInt32 {
    case normal = 0
    case used = 1
    case update = 2
}

class NumberBox: SKSpriteNode {
    var currentTexture = SKTexture()
    
    let normText: SKTexture = SKTexture(imageNamed: "numberNormal")
    let usedText: SKTexture = SKTexture(imageNamed: "numberGreyedOut")
    
    var array = [Int]()
    var indexs = 0
    
    internal var currentState : boxStates = .normal
    
    var number = SKLabelNode()
    var numberShadow = SKLabelNode()
    var numberInt = 0
    
    var timer = NSTimer()
    
    init(texture : SKTexture?, color: UIColor, size: CGSize, index: Int?) {
        currentTexture = normText
        super.init(texture: currentTexture, color: color, size: size)
        
        self.size = currentTexture.size()
        self.setScale(0)
        
        let random = arc4random_uniform(2)+1
        
        if random == 3 {
            self.zRotation = 0.75
        }
        
        number.fontName = "Montserrat-Bold"
        number.text = "\(indexs)"
        number.fontColor = UIColor.whiteColor()
        number.zPosition = 2
        number.fontSize = 30
        number.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        number.horizontalAlignmentMode = .Center
        number.verticalAlignmentMode = .Center
        self.addChild(number)
        
        numberShadow.fontName = "Montserrat-Bold"
        numberShadow.text = "\(indexs)"
        numberShadow.fontColor = UIColor(rgba: "#d24536")
        numberShadow.zPosition = 1
        numberShadow.fontSize = 30
        numberShadow.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-5)
        numberShadow.horizontalAlignmentMode = .Center
        numberShadow.verticalAlignmentMode = .Center
        self.addChild(numberShadow)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
    }
    
    func switchStates () {
        switch currentState {
        case .normal:
            currentTexture = normText
            texture = currentTexture
            break;
        case .update:
            if indexs > 0 {
                number.text = "\(indexs)"
                numberShadow.text = "\(indexs)"
                timer.invalidate()
            }
            
            let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI * 2), duration: 1)
            self.runAction(rotateAction)
            
            break;
        case .used:
            let scaleSequence = SKAction.sequence([SKAction.scaleTo(0.9, duration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0), SKAction.scaleTo(1, duration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)])
            self.runAction(scaleSequence)
            currentTexture = usedText
            self.texture = currentTexture

        }
    }
    
    func flip () {
        
        let liftUp = SKAction.scaleTo(1.2, duration: 0.2)
        let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
        
        let touchAction = SKAction.sequence([liftUp, dropDown])
        
        let flip = SKAction.scaleXTo(-1, duration: 0.4)
        
        self.setScale(1.0)
        
        let changeColor = SKAction.runBlock( { self.number.alpha = 0; self.numberShadow.alpha = 0})
        let action = SKAction.sequence([flip, changeColor] )
        
        let finishedAction = SKAction.group([touchAction, action])
        
        self.runAction(finishedAction)
    }
    
    func reFlip () {
        let liftUp = SKAction.scaleTo(1.2, duration: 0.2)
        let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
        
        let touchAction = SKAction.sequence([liftUp, dropDown])
        
        let flip = SKAction.scaleXTo(-1, duration: 0.4)
        
        self.setScale(1.0)
        
        let changeColor = SKAction.runBlock( { self.number.alpha = 1; self.numberShadow.alpha = 1})
        let action = SKAction.sequence([flip, changeColor] )
        
        let finishedAction = SKAction.group([touchAction, action])
        
        self.runAction(finishedAction)

    }
    
    func normal () {
        currentState = .normal
        switchStates()
    }
    
    func update () {
        currentState = .update
        switchStates()
    }
    
    func used () {
        currentState = .used
        switchStates()
    }
    
    func darken () {
        let scaleSequence = SKAction.sequence([SKAction.scaleTo(0.95, duration: 0.1), SKAction.scaleTo(1, duration: 0.1)])
        self.runAction(scaleSequence)
        currentTexture = SKTexture(imageNamed: "numberGreyedOut")
        self.texture = currentTexture
    }
    
    func scale () {
        self.runAction(SKAction.scaleTo(1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
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
    
    func randomWord() {
       
        let getRandom = randomSequenceGenerator(1, max: 99)
        for _ in 1...24 {
            array.append(getRandom());
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PopUp : SKSpriteNode {
    var currentTexture = SKTexture()
    
    let yesButton = SKSpriteNode(imageNamed: "yes")
    let noButton = SKSpriteNode(imageNamed: "no")
    let timeButton = SKSpriteNode(imageNamed: "timeBG")
    let plus = SKSpriteNode(imageNamed: "plus")
    let minus = SKSpriteNode(imageNamed: "minus")
    
    let timeSecondsText = SKLabelNode(fontNamed: "Montserrat-Regular")
    let timeText = SKLabelNode(fontNamed: "Montserrat-Regular")
    let memoryText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    
    let youHaveText = SKLabelNode(fontNamed: "Montserrat-Light")
    let gameTimeText = SKLabelNode(fontNamed: "Montserrat-Light")
    let secondsText = SKLabelNode(fontNamed: "Montserrat-Light")
    let toRememberText = SKLabelNode(fontNamed: "Montserrat-Light")
    let allText = SKLabelNode(fontNamed: "Montserrat-Regular")
    let theTilesText = SKLabelNode(fontNamed: "Montserrat-Light")
    
    var time = 30
    var currentTime = 30
    
    let normText = SKTexture(imageNamed: "popup")
    
    init() {
        currentTexture = normText
        super.init(texture: currentTexture, color: UIColor.clearColor(), size: currentTexture.size())
        
        self.zPosition = 10
        self.userInteractionEnabled = true
        
        yesButton.position = CGPointMake(0.758, -110.595)
        yesButton.zPosition = 33
        yesButton.userInteractionEnabled = true
        yesButton.name = "yesButton"
        addChild(yesButton)
        
        noButton.position = CGPointMake(0.758, -159.627)
        noButton.zPosition = 33
        addChild(noButton)
        
        timeButton.position = CGPointMake(0.375, -51.727)
        timeButton.zPosition = 33
        addChild(timeButton)
        
        plus.position = CGPointMake(-90.229, -54)
        plus.setScale(2)
        plus.zPosition = 33
        addChild(plus)
        
        minus.position = CGPointMake(88.531, -54)
        minus.zPosition = 33
        minus.setScale(2)
        addChild(minus)
        
        timeSecondsText.text = "SECONDS"
        timeSecondsText.fontSize = 16
        timeSecondsText.fontColor = UIColor.whiteColor()
        timeSecondsText.zPosition = 33
        timeSecondsText.horizontalAlignmentMode = .Center
        timeSecondsText.verticalAlignmentMode = .Baseline
        timeSecondsText.position = CGPointMake(13.763, -5.538)
        timeButton.addChild(timeSecondsText)
        
        timeText.text = String(time)
        timeText.fontSize = 16
        timeText.fontColor = UIColor.whiteColor()
        timeText.zPosition = 33
        timeText.horizontalAlignmentMode = .Center
        timeText.verticalAlignmentMode = .Baseline
        timeText.position = CGPointMake(-39.237, -5.538)
        timeButton.addChild(timeText)
        
        memoryText.text = "MEMORY MODE"
        memoryText.position = CGPointMake(-0.5, 146.859)
        memoryText.horizontalAlignmentMode = .Center
        memoryText.verticalAlignmentMode = .Baseline
        memoryText.zPosition = 33
        memoryText.fontColor = UIColor.whiteColor()
        memoryText.fontSize = 28.5
        addChild(memoryText)
        
        youHaveText.text = "you have"
        youHaveText.position = CGPointMake(1.882, 105.636)
        youHaveText.horizontalAlignmentMode = .Center
        youHaveText.verticalAlignmentMode = .Baseline
        youHaveText.fontColor = UIColor.whiteColor()
        youHaveText.fontSize = 24
        youHaveText.zPosition = 33
        addChild(youHaveText)
        
        gameTimeText.text = String(currentTime)
        gameTimeText.position = CGPointMake(2.882, 36.637)
        gameTimeText.horizontalAlignmentMode = .Center
        gameTimeText.verticalAlignmentMode = .Baseline
        gameTimeText.fontColor = UIColor.whiteColor()
        gameTimeText.fontSize = 80
        gameTimeText.zPosition = 33
        addChild(gameTimeText)
        
        secondsText.text = "seconds"
        secondsText.position = CGPointMake(3.882, 4.368)
        secondsText.horizontalAlignmentMode = .Center
        secondsText.verticalAlignmentMode = .Baseline
        secondsText.fontColor = UIColor.whiteColor()
        secondsText.fontSize = 24
        secondsText.zPosition = 33
        addChild(secondsText)
        
        toRememberText.text = "to remember"
        toRememberText.position = CGPointMake(-44.347, -16.632)
        toRememberText.horizontalAlignmentMode = .Center
        toRememberText.verticalAlignmentMode = .Baseline
        toRememberText.fontColor = UIColor.whiteColor()
        toRememberText.fontSize = 15
        toRememberText.zPosition = 33
        addChild(toRememberText)
        
        allText.text = "ALL"
        allText.position = CGPointMake(14.653, -16.632)
        allText.horizontalAlignmentMode = .Center
        allText.verticalAlignmentMode = .Baseline
        allText.fontColor = UIColor.whiteColor()
        allText.fontSize = 14
        allText.zPosition = 33
        addChild(allText)
        
        theTilesText.text = "the lines"
        theTilesText.position = CGPointMake(62.653, -16.632)
        theTilesText.horizontalAlignmentMode = .Center
        theTilesText.verticalAlignmentMode = .Baseline
        theTilesText.fontColor = UIColor.whiteColor()
        theTilesText.fontSize = 15
        theTilesText.zPosition = 33
        addChild(theTilesText)
        
        for child in self.children {
            child.userInteractionEnabled = true
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            handleTouchedLocation(location)
        }
        
    }
    
    func handleTouchedLocation (location: CGPoint) {
        
        if yesButton.containsPoint(location) {
            self.runAction(SKAction.moveToY(1000, duration: 1), completion: {
                self.removeAllActions()
                self.removeAllChildren()
                self.removeFromParent()
            })
            
            NSNotificationCenter.defaultCenter().postNotificationName("initScene", object: nil)
            
        }
    }
    
    init(texture: SKTexture!) {
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}