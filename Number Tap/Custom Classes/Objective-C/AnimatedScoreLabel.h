//
//  NTAnimatedScoreLabel.h
//  Number Tap
//
//  Created by jesse on 27/03/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AnimatedScoreLabel : SKLabelNode

+(AnimatedScoreLabel *)labelWithText:(NSString *)text score:(int)score size:(int)fontSize color:(UIColor *)fontColor;
@property (nonatomic) int score;

@end
