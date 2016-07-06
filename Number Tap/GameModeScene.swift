//
//  GameModeScene.swift
//  Number Tap
//
//  Created by jesse on 03/04/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit

class GameModes: SKScene {
    let background  = SKSpriteNode(imageNamed: "background")
    let titleBG     = SKSpriteNode(imageNamed: "titleBG")
    let gameModes   = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
    let shootRibbon = Ribbon(ribbonType: .Shoot, bodyColour: .Red, dotsColour: .Red)
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFill
        size = CGSizeMake(640, 960)
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.size = self.size
        background.zPosition = -1
        addChild(background)
        
        titleBG.position = CGPointMake(CGRectGetMidX(self.frame), 900)
        titleBG.setScale(1.3)
        
        gameModes.text = NSLocalizedString("game-modes", comment: "Game Modes")
        gameModes.horizontalAlignmentMode = .Center
        gameModes.verticalAlignmentMode = .Center
        gameModes.zPosition = 10
        gameModes.fontSize = 65

        titleBG.addChild(gameModes)
        
        let gameModesShadow = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
        gameModesShadow.color = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        gameModesShadow.alpha = 0.21
        gameModesShadow.position = CGPointMake(gameModes.position.x, gameModes.position.y - 3)
        gameModesShadow.horizontalAlignmentMode = .Center
        gameModesShadow.verticalAlignmentMode = .Center
        gameModesShadow.zPosition = 10
        gameModesShadow.fontSize = 65
        titleBG.addChild(gameModesShadow)
        addChild(titleBG)
        
        shootRibbon.position = CGPointMake(203, 651)
        shootRibbon.setScale(1.5)
        addChild(shootRibbon)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
        }
    }
}
