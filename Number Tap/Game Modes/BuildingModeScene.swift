//
//  BuildingModeScene.swift
//  Number Tap
//
//  Created by jesse on 09/06/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import UIKit
import SpriteKit

class BuildingModeScene: SKScene {
    let background = SKSpriteNode(imageNamed: "background")
    var boxArray = [NumberBox]()
    var touchableArray = [NumberBox]()
    var array = [Int]()
    var spareArray = [Int]()
    
    var score : Int = 0
    var number : Int = 0
    var tutorial = 0
    
    override func didMoveToView(view: SKView) {
        size = CGSizeMake(640, 960)
        backgroundColor = UIColor(red: 40, green: 40, blue: 40, alpha: 1)
        scaleMode = .AspectFill
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.size = self.size
        background.zPosition = -10
        addChild(background)
        
        setupBoxes()
    }
    
    func setupBoxes() {
        randomWord()
        
        for var i = 1; i < 25; i++ {
            var posY : CGFloat = 700
            var posX : CGFloat = 170
            var index = i - 1
            
            switch i {
            case let i where i == 1 || i == 2 || i == 3  || i == 4 :
                posY = 700
                break;
            case let i where i == 5 || i == 6 || i == 7  || i == 8 :
                posY = 600
                break;
            case let i where i == 9 || i == 10 || i == 11  || i == 12 :
                posY = 500
                break;
            case let i where i == 13 || i == 14 || i == 15  || i == 16 :
                posY = 400
                break;
            case let i where i == 17 || i == 18 || i == 19  || i == 20 :
                posY = 300
                break;
            case let i where i == 21 || i == 22 || i == 23  || i == 24 :
                posY = 200
                break;
                
            default:
                posY = 700
                break;
            }
            
            if i == 1 || i == 5 || i == 9 || i == 13 || i == 17 || i == 21 {
                posX = 170
            };
            
            if i == 2 || i == 6 || i == 10 || i == 14 || i == 18 || i == 22 {
                posX = 270
            };
            
            if i == 3 || i == 7 || i == 11 || i == 15 || i == 19 || i == 23 {
                posX = 370
            };
            
            if i == 4 || i == 8 || i == 12 || i == 16 || i == 20 || i == 24 {
                posX = 470
            }
            
            let box = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500) , index: nil)
            box.position = CGPointMake(posX, posY)
            box.zPosition = background.zPosition + 1
            box.name = "numberBox" + String(i)
            box.indexs = array[index]
            box.index = i
            addChild(box)
            
            boxArray.append(box)
            
            print("\n\n\n Yea yea X \(posX) & Y \(posY) for box number \(i) \n\n\n")
            
        }
        
        randomBoxFromArray(boxesArray: boxArray, howManyBoxes: 1)
    }
    
    //MARK: Game Logic
    func makeBoxVisible(box: NumberBox) {
        box.alpha = 1
        box.scale()
        touchableArray.append(box)
    }
    
    func randomBoxFromArray(boxesArray array: [NumberBox], howManyBoxes howMuch: Int) {
        for i in 0 ..< howMuch {
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            let randomBox = array[randomIndex]
            
            makeBoxVisible(randomBox)
        }
    }
    
    func randomWord() {
        
        let getRandom = randomSequenceGenerator(1, max: 99)
        for i in 1...24 {
            array.append(getRandom());
            
        }
        
        for i in 1...99 {
            spareArray.append(getRandom())
            spareArray = Array(Set(spareArray).subtract(array))
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
    
    //MARK: Touch methods
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            handleTouchedPoint(location)
        }
    }
    
    func handleTouchedPoint(location: CGPoint) {
        for touchableBox in touchableArray {
            touchableBox.flip()
            touchableBox.indexs = spareArray[touchableBox.index]
            touchableBox.update()
            touchableBox.reFlip()
            let randomNumber = Int(arc4random_uniform(3) + 1)
            randomBoxFromArray(boxesArray: boxArray, howManyBoxes: randomNumber)
        }
    }
}
