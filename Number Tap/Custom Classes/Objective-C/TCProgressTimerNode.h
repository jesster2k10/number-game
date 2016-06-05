//
//  TCProgressTimerNode.h
//  Number Tap
//
//  Created by jesse on 10/04/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TCProgressTimerNode : SKNode

@property (nonatomic) CGFloat progress;

- (instancetype)initWithForegroundImageNamed:(NSString *)foregroundImageName
                        backgroundImageNamed:(NSString *)backgroundImageName
                         accessoryImageNamed:(NSString *)accessoryImageName;

- (instancetype)initWithForegroundTexture:(SKTexture *)foregroundTexture
                        backgroundTexture:(SKTexture *)backgroundTexture
                         accessoryTexture:(SKTexture *)accessoryTexture;

- (instancetype)initWithRadius:(CGFloat)radius
               backgroundColor:(UIColor *)backgroundColor
               foregroundColor:(UIColor *)foregroundColor;

@end

