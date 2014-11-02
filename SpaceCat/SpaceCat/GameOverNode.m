//
//  GameOverNode.m
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/2/14.
//
//

#import "GameOverNode.h"
#import "GameScene.h"
#import "Util.h"

@implementation GameOverNode

+ (instancetype)gameOverAtPosition:(CGPoint)position {
    GameOverNode *gameOver = [self node];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    gameOverLabel.name = GameOverLabelName;
    gameOverLabel.text = GameOverLabelText;
    gameOverLabel.fontSize = GameOverLabelFontSize;
    gameOverLabel.position = position;
    [gameOver addChild:gameOverLabel];
    
    return gameOver;
}

- (void) performAnimationWithScene:(GameScene *)scene {
    SKLabelNode *gameOverLabel = (SKLabelNode *)[self childNodeWithName:GameOverLabelName];
    gameOverLabel.xScale = 0;
    gameOverLabel.yScale = 0;
    SKAction *scapeUp = [SKAction scaleTo:1.2f duration:0.75f];
    SKAction *scaleDown = [SKAction scaleTo:0.9f duration:0.25f];
    SKAction *run = [SKAction runBlock:^{
        SKLabelNode *touchToRestart = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        touchToRestart.fontSize = GameOverLabelFontSize / 2;
        touchToRestart.text = @"Touch To Restart";
        touchToRestart.position = CGPointMake(gameOverLabel.position.x,
                                              gameOverLabel.position.y - Margin * 2);
        
        [self addChild:touchToRestart];
        scene.restart = YES;
    }];
    
    SKAction *scaleSequence = [SKAction sequence:@[scapeUp, scaleDown, run]];
    [gameOverLabel runAction:scaleSequence];
}

@end
