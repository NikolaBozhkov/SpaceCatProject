//
//  TitleScene.m
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import "TitleScene.h"
#import "GameScene.h"
#import <AVFoundation/AVFoundation.h>

@interface TitleScene ()

@property (nonatomic) SKAction *pressStartSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;

@end

@implementation TitleScene

- (void)didMoveToView:(SKView *)view {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash_1"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@".mp3"];
    
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic prepareToPlay];
    [self.backgroundMusic play];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.backgroundMusic stop];
    [self runAction:self.pressStartSFX];
    
    SKScene *gameScene = [GameScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    
    [self.view presentScene:gameScene transition:transition];
}

@end
