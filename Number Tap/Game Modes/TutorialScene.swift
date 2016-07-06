//
//  TutorialScene.swift
//  Number Tap
//
//  Created by jesse on 14/06/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialScene: SKScene {
    var boxArray = [NumberBox]()
    var array = [Int]()
    
    var score : Int = 0
    var number : Int = 0
    var tutorial = 0
    
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
    
    let background = SKSpriteNode(imageNamed: "background")
    let starVideo = SKSpriteNode(imageNamed: "starVideo")
    let records = SKSpriteNode(imageNamed: "records")
    var scoreLabel = AnimatedScoreLabel(text: "Score", score: 0, size: 25, color: k.flatColors.red)
    var numbersTap = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    var tapOnLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let numberLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let circularTimer = ProgressNode()
    
    let tut1 = TutorialBox(withType: .Regular, lineOne: "Find this number", lineTwo: nil, lineThree: nil, fontSize : 16)
    let tut2 = TutorialBox(withType: .Regular, lineOne: "Tap the number!", lineTwo: nil, lineThree: nil, fontSize : 16)
    
    override func didMoveToView(view: SKView) {
        FTLogging().FTLog("Tutorial scene initiated")
        
        size = CGSizeMake(640, 960)
        backgroundColor = UIColor(red: 40, green: 40, blue: 40, alpha: 1)
        scaleMode = .AspectFill
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.size = self.size
        background.zPosition = -10
        addChild(background)
        
        randomWord()
        initGame()

    }
    
    //Init
    func initScene() {
        tutorial = 1
        let timerSpace = SKTexture(imageNamed: "timerSpace")
        circularTimer.position = CGPointMake(numberBox4.position.x, 850)
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
        
        createTutorial(tutorialWithNumber: 1)
    }
    
    func initGame() {
        
        score = 0
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
        
        tapOnLabel.fontColor = UIColor.whiteColor()
        tapOnLabel.fontSize = 30
        tapOnLabel.text = "TAP NUMBER:"
        tapOnLabel.horizontalAlignmentMode = .Center
        tapOnLabel.verticalAlignmentMode = .Center
        tapOnLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 25, 90)
        addChild(tapOnLabel)
        
        numberLabel.fontColor = UIColor(rgba: "#e74c3c")
        numberLabel.fontSize = 38
        numberLabel.text = String(numberBox12.indexs)
        numberLabel.horizontalAlignmentMode = .Center
        numberLabel.verticalAlignmentMode = .Center
        numberLabel.position = CGPointMake(self.tapOnLabel.position.x + 130, 90)
        addChild(numberLabel)
        
        for box in boxArray {
            box.setScale(1)
        }
        
        initScene()
    }
    
    func createTutorial(tutorialWithNumber number: Int) {
        
        if number == 1 {
            tut1.position = CGPoint(x: numberLabel.position.x, y: numberLabel.position.y + 55)
            tut1.zPosition = 25
            tut1.name = "tut1"
            addChild(tut1)
            
            tut1.bounce()
        }
            
        else if number == 2 {
            tut2.position = CGPointMake(numberBox12.position.x, numberBox12.position.y + 80)
            tut2.zPosition = 25
            tut2.name = "tut" + String(number)
            addChild(tut2)
            
            tut2.bounce()
        }
        
        else if number == 3 {
            let tut3 = TutorialBox(withType: .Down, lineOne: "Great Job!", lineTwo: "This is the clock", lineThree: nil, fontSize : 16)
            tut3.position = CGPointMake(circularTimer.position.x, circularTimer.position.y - 65)
            tut3.zPosition = 25
            tut3.name = "tut" + String(number)
            addChild(tut3)
            
            tut3.bounce()
        }
    }

    
    //Game Logic
    func randomWord() {
        
        let getRandom = randomSequenceGenerator(1, max: 99)
        for _ in 1...24 {
            array.append(getRandom());
            
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if tutorial == 1 {
            let fade = SKAction.fadeAlphaTo(0, duration: 0.5)
            tut1.runAction(fade, completion: {
                self.createTutorial(tutorialWithNumber: 2)
            })
            tutorial += 1
        }
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            handleTouchedPoint(location, node: node)
        }
    }
    
    func handleTouchedPoint(location: CGPoint, node: SKNode) {
        
        if numberBox12.containsPoint(location) {
            if tutorial == 2 {
                tutorial += 1
                let fade = SKAction.fadeAlphaTo(0, duration: 0.5)
                tut2.runAction(fade, completion: {
                    self.createTutorial(tutorialWithNumber: 3)
                })
            }
        }
        
        if node.name == "tut3" {
            if tutorial == 3 {
                tutorial += 1
                let tutNode = node as! TutorialBox
                let fade = SKAction.fadeAlphaTo(0, duration: 1)
                tutNode.runAction(fade, completion: {
                    self.createTutorial(tutorialWithNumber: 4)
                })
            }
        }
    }
}
