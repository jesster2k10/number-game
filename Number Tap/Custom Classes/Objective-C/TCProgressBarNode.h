//
//  TCProgressBarNode.h
//  Number Tap
//
//  Created by jesse on 10/04/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TCProgressBarNode : SKNode

/** Current progress of the progress bar, value between 0.0 and 1.0 */
@property (nonatomic) CGFloat progress;

/** Configurable title label, displayed centered in the progress bar by default */
@property (nonatomic, strong, readonly) SKLabelNode *titleLabelNode;

/** Initialize a plain progress bar with the given colors and sizes. */
- (instancetype)initWithSize:(CGSize)size
             backgroundColor:(UIColor *)backgroundColor
                   fillColor:(UIColor *)fillColor
                 borderColor:(UIColor *)borderColor
                 borderWidth:(CGFloat)borderWidth
                cornerRadius:(CGFloat)cornerRadius;

/** Initialize a custom progress bar with the given textures for background, fill and overlay layers */
- (instancetype)initWithBackgroundTexture:(SKTexture *)backgroundTexture
                              fillTexture:(SKTexture *)fillTexture
                           overlayTexture:(SKTexture *)overlayTexture;

/** Update the current progress or the progress bar, value between 0.0 and 1.0 */
- (void)setProgress:(CGFloat)progress;

@end