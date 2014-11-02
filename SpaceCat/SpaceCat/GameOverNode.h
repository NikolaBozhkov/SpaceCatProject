//
//  GameOverNode.h
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/2/14.
//
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface GameOverNode : SKNode

+ (instancetype) gameOverAtPosition:(CGPoint)position;

- (void) performAnimationWithScene:(GameScene *)scene;

@end
