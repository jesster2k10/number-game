//
//  TCProgressTimerForegroundCropNode.h
//  Number Tap
//
//  Created by jesse on 10/04/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TCProgressTimerForegroundCropNode : SKCropNode

@property (nonatomic) CGFloat progress;

- (id)initWithTexture:(SKTexture *)texture;

@end
