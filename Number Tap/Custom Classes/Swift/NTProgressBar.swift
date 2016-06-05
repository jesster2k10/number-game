//
//  NTProgressBar.swift
//  Number Tap
//
//  Created by jesse on 22/03/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit

class NTProgressBar: SKCropNode {
    
    internal var currentProgress : CGFloat = 0.0
    
    override init() {
        super.init()
        
        maskNode = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(300, 20))
        
        let progress = SKSpriteNode(imageNamed: "progressBar")
        addChild(progress)
        
    }
    
    internal func setProgress (progress: CGFloat) {
        currentProgress = progress
        maskNode?.xScale = currentProgress
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
