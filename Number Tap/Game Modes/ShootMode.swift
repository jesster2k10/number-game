//
//  ShootMode.swift
//  Number Tap
//
//  Created by jesse on 05/07/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit

struct Physics {
    static let Box : UInt32 = 0x1 << 0
    static let Bullet : UInt32 = 0x1 << 1
    static let Ball : UInt32 = 0x1 << 2
}

class Shoot : BaseScene, SKPhysicsContactDelegate {
    
    let mainBall = SKShapeNode(circleOfRadius: 75)
    var boxTimer = NSTimer()
    
    var index = 0
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        view.showsPhysics = true
        
        randomWord()
        
        mainBall.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        mainBall.fillColor = k.flatColors.red
        mainBall.strokeColor = UIColor.clearColor()
        mainBall.zPosition = 10.0
        mainBall.name = "ball"
        addChild(mainBall)
        
        mainBall.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        mainBall.physicsBody?.categoryBitMask = Physics.Ball
        mainBall.physicsBody?.contactTestBitMask = Physics.Box
        mainBall.physicsBody?.collisionBitMask = Physics.Box
        mainBall.physicsBody?.affectedByGravity = false
        mainBall.physicsBody?.dynamic = false
        
        boxTimer = NSTimer.every(3.0, {
            self.spawnNumbers(withDuration: 3.0)
        })
    }
    
    
    func spawnNumbers(withDuration duration: NSTimeInterval) {
        let numberBox = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
        numberBox.indexs = avaliableNumbers[index]
        numberBox.zPosition = 0
        index += 1
        
        numberBox.physicsBody = SKPhysicsBody(rectangleOfSize: numberBox.texture!.size())
        numberBox.physicsBody?.categoryBitMask = Physics.Box
        numberBox.physicsBody?.contactTestBitMask = Physics.Ball
        numberBox.physicsBody?.collisionBitMask = Physics.Ball
        numberBox.physicsBody?.dynamic = false
        numberBox.physicsBody?.affectedByGravity = false
        numberBox.name = "box"
        
        let randY = CGFloat(arc4random_uniform(UInt32(frame.size.height)))
        let randX = CGFloat(arc4random_uniform(UInt32(frame.size.width)))
        let randPos = arc4random() % 4
        
        switch randPos {
        case 0:
            numberBox.position.x = 0
            numberBox.position.y = randY
            addChild(numberBox)
            numberBox.scale()
            break;
            
        case 1:
            numberBox.position.x = randX
            numberBox.position.y = 0
            addChild(numberBox)
            numberBox.scale()
            break
            
        case 2:
            numberBox.position.x = randX
            numberBox.position.y = frame.size.height
            addChild(numberBox)
            numberBox.scale()
            break
            
        case 3:
            numberBox.position.x = frame.size.width
            numberBox.position.y = randY
            addChild(numberBox)
            numberBox.scale()
            break
        
        default:
            numberBox.position.x = 0
            numberBox.position.y = randY
            addChild(numberBox)
            numberBox.scale()
        }
        
        numberBox.runAction(SKAction.moveTo(mainBall.position, duration: duration))
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.node!
        let secondBody = contact.bodyB.node!
        
        if firstBody.name  == "box" && secondBody.name == "bullet" {
            collisionBullet(withBox: firstBody as! NumberBox, andBullet: secondBody as! SKShapeNode)
        } else if firstBody.name == "bullet" && secondBody.name == "box" {
            collisionBullet(withBox: secondBody as! NumberBox, andBullet: firstBody as! SKShapeNode)
        } else if firstBody.name  == "ball" && secondBody.name == "box" {
            collisionMain(withBox: secondBody as! NumberBox)
        } else if firstBody.name  == "box" && secondBody.name == "ball" {
            collisionMain(withBox: firstBody as! NumberBox)
        }
    }
    
    func collisionMain(withBox box: NumberBox) {
        
            let changeToRed = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.5)
            let changeToNorm = SKAction.colorizeWithColor(k.flatColors.red, colorBlendFactor: 1.0, duration: 0.5)
            mainBall.runAction(SKAction.scaleBy(1.5, duration: 0.4))
            mainBall.runAction(SKAction.sequence([changeToRed, changeToNorm]))
            boxTimer.invalidate()
        
    }
    
    func collisionBullet(withBox box: NumberBox, andBullet bullet: SKShapeNode) {
        print("Collided")
        box.physicsBody?.dynamic = true
        box.physicsBody?.affectedByGravity = true
        box.physicsBody?.mass = 5.0
        
        bullet.physicsBody?.mass = 5.0
        
        box.removeAllActions()
        bullet.removeAllActions()
    }
    
    func point() {
        NSLog("Point")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let bullet = SKShapeNode(circleOfRadius: 15)
            bullet.position = mainBall.position
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: 15)
            bullet.physicsBody?.affectedByGravity = false
            bullet.fillColor = mainBall.fillColor
            bullet.strokeColor = mainBall.fillColor
            bullet.name = "bullet"
            
            bullet.physicsBody?.categoryBitMask = Physics.Bullet
            bullet.physicsBody?.collisionBitMask = Physics.Box
            bullet.physicsBody?.contactTestBitMask = Physics.Box
            
            var dx = CGFloat(location.x - mainBall.position.x)
            var dy = CGFloat(location.y - mainBall.position.y)
            
            let magnitude = sqrt(dx * dx + dy * dy)
            
            dx /= magnitude
            dy /= magnitude
            
            let vector = CGVector(dx: 16.0 * dx, dy: 16.0 * dy)
            
            addChild(bullet)
            
            bullet.physicsBody?.applyImpulse(vector)
        }
    }
    
    
}
