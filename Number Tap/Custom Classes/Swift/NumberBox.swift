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

enum tutorialTypes : String {
    case Regular = "tutorialBig"
    case BigRegular = "bigRegular"
    case Down = "tutorialDown"
    case BigDown = "bigDown"
}

class NumberBox: SKSpriteNode {
    var currentTexture = SKTexture()
    
    let normText: SKTexture = SKTexture(imageNamed: "numberNormal")
    let usedText: SKTexture = SKTexture(imageNamed: "numberGreyedOut")
    
    var array = [Int]()
    var indexs = 0
    var index = 0
    
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
    
    func reScale (withCompletion completion: () -> ()) {
        self.runAction(SKAction.scaleTo(0, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)) { 
            completion()
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
class TutorialBox : SKSpriteNode {
    
    var currentTexture = SKTexture()
    var currentType : tutorialTypes!
    var hasAnimationFinished = false
    
    let lineOne = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let lineTwo = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let lineThree = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    
    init(withType type: tutorialTypes, lineOne l1: String, lineTwo l2: String?, lineThree l3: String?, fontSize size: CGFloat) {
        currentTexture = SKTexture(imageNamed: tutorialTypes.Regular.rawValue)
        super.init(texture: currentTexture, color: UIColor.clearColor(), size: currentTexture.size())
        
        currentType = type
        
        if currentType == .BigDown || currentType == .Down {
            zRotation = 180
        }
        
        lineOne.zPosition = 999
        lineTwo.zPosition = 999
        lineThree.zPosition = 999
        
        
        if l2 == nil && l3 == nil {
            
            lineOne.verticalAlignmentMode = .Baseline
            lineOne.horizontalAlignmentMode = .Center
            lineOne.text = l1
            lineOne.fontSize = size
            lineOne.fontColor = UIColor.blackColor()
            //lineOne.position = CGPointMake(-0.5, 0.947)
            addChild(lineOne)
            
        } else if l2 != nil || l3 != nil{
            
            lineOne.verticalAlignmentMode = .Baseline
            lineOne.horizontalAlignmentMode = .Center
            lineOne.text = l1
            lineOne.fontSize = 15
            lineOne.fontColor = UIColor.blackColor()
            lineOne.position = CGPointMake(-1.013, 17.7)
            addChild(lineOne)
            
            lineTwo.verticalAlignmentMode = .Baseline
            lineTwo.horizontalAlignmentMode = .Center
            lineTwo.text = l2
            lineTwo.fontSize = 15
            lineTwo.fontColor = UIColor.blackColor()
            lineTwo.position = CGPointMake(-1.013, 2.081)
            addChild(lineTwo)
            
            lineThree.verticalAlignmentMode = .Baseline
            lineThree.horizontalAlignmentMode = .Center
            lineThree.text = l3
            lineThree.fontSize = 15
            lineThree.fontColor = UIColor.blackColor()
            lineThree.position = CGPointMake(-1.013, -13.538)
            addChild(lineThree)
            
        } else if l2 != nil && l3 == nil {
            
            lineOne.verticalAlignmentMode = .Top
            lineOne.horizontalAlignmentMode = .Center
            lineOne.text = l1
            lineOne.fontSize = 15
            lineOne.fontColor = UIColor.blackColor()
            lineOne.position = CGPointMake(-0.771, 25.947)
            addChild(lineOne)
            
            lineTwo.verticalAlignmentMode = .Baseline
            lineTwo.horizontalAlignmentMode = .Center
            lineTwo.text = l2!
            lineTwo.fontSize = 15
            lineTwo.fontColor = UIColor.blackColor()
            lineTwo.position = CGPointMake(-0.771, -8.053)
            addChild(lineTwo)
        }
        setScale(0)
    }
    
    func bounce () {
        var scale = SKAction()
        
        if currentType == .BigRegular || currentType == .BigDown {
            scale = SKAction.scaleTo(1.088, duration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        } else {
            
            scale = SKAction.scaleTo(1, duration: 2, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        }
        
        runAction(scale)
    }
    
    func reBounce() {
        let scale = SKAction.scaleTo(0.005, duration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        runAction(scale) { 
            self.hasAnimationFinished = true
        }
        
        
    }
    
    func isFinished () -> Bool {
        return hasAnimationFinished
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

