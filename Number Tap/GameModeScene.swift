//
//  GameModeScene.swift
//  Number Tap
//
//  Created by jesse on 03/04/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit

class GameModeScene: SKScene {
    let background = SKSpriteNode(imageNamed: "background")
    let normalMode = SKSpriteNode(imageNamed: "normal")
    let endlessMode = SKSpriteNode(imageNamed: "endless")
    let memoryMode = SKSpriteNode(imageNamed: "memory")
    let pickAMode = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFill
        size = CGSizeMake(640, 960)
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.zPosition = -10
        background.size = self.size
        addChild(background)
        
        endlessMode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        endlessMode.zPosition = 2
        addChild(endlessMode)
        
        normalMode.position = CGPointMake(endlessMode.position.x, endlessMode.position.y + 80)
        normalMode.zPosition = 2
        
        memoryMode.position = normalMode.position
        memoryMode.zPosition = 2
        addChild(memoryMode)
        
        pickAMode.position = CGPointMake(normalMode.position.x, normalMode.position.y + 110)
        pickAMode.zPosition = 2
        pickAMode.fontSize = 67
        pickAMode.text = "pick a mode"
        pickAMode.fontColor = UIColor.whiteColor()
        pickAMode.horizontalAlignmentMode = .Center
        addChild(pickAMode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if endlessMode.containsPoint(location) {
                NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "gameMode")
                let gameScene = GameScene()
                self.view?.presentScene(gameScene, transition: SKTransition.fadeWithColor(UIColor(rgba : "#434343"), duration: 1))
                endlessMode.runAction(k.Sounds.blopAction1)

            };
            
            if memoryMode.containsPoint(location) {
                NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "gameMode")
                let gameScene = GameScene()
                self.view?.presentScene(gameScene, transition: SKTransition.fadeWithColor(UIColor(rgba: "#434343"), duration: 1))
                memoryMode.runAction(k.Sounds.blopAction1)

            }
        }
    }
}
