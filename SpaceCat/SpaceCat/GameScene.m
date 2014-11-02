//
//  GameScene.m
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "GroundNode.h"
#import "MachineNode.h"
#import "SpaceCatNode.h"
#import "ProjectileNode.h"
#import "SpaceDogNode.h"
#import "HudNode.h"
#import "GameOverNode.h"
#import "Util.h"
#import <AVFoundation/AVFoundation.h>

@interface GameScene ()<SKPhysicsContactDelegate>

@property NSTimeInterval lastUpdateTimeInterval;
@property NSTimeInterval timeSinceEnemyAdded;
@property NSTimeInterval enemySpawnTimeInterval;
@property NSTimeInterval enemyMinSpeed;
@property NSTimeInterval totalGameTime;

@property BOOL gameOver;
@property BOOL gameOverDispayed;

@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *laserSFX;
@property (nonatomic) SKAction *explodeSFX;

@property (nonatomic) AVAudioPlayer *backgroundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;

@end

@implementation GameScene {
    GroundNode *ground;
    MachineNode *machine;
    SpaceCatNode *spaceCat;
}

- (void) didMoveToView:(SKView *)view {
    self.lastUpdateTimeInterval = 0;
    self.timeSinceEnemyAdded = 0;
    self.totalGameTime = 0;
    self.enemySpawnTimeInterval = EnemyInitialSpawnTimeInterval;
    self.enemyMinSpeed = SpaceDogMinSpeed;
    
    self.gameOver = NO;
    self.gameOverDispayed = NO;
    self.restart = NO;
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.zPosition = -1;
    [self addChild:background];
    
    SKNode *hud = [HudNode hudAtPosition:CGPointMake(0, self.frame.size.height - Margin) withFrame:self.frame];
    [self addChild:hud];
    
    self.physicsWorld.gravity = CGVectorMake(0, -9.8);
    self.physicsWorld.contactDelegate = self;
    
    ground = [GroundNode groundWithSize:CGSizeMake(self.frame.size.width, GroundHeight)];
    ground.zPosition = 1;
    [self addChild:ground];
    
    CGPoint machinePosition = CGPointMake(CGRectGetMidX(self.frame), MachinePositionY);
    machine = [MachineNode machineWithPosition:machinePosition];
    [self addChild:machine];
    
    CGPoint spaceCatPosition = CGPointMake(machine.position.x, machine.position.y - 2);
    spaceCat = [SpaceCatNode spaceCatWithPosition:spaceCatPosition];
    [self addChild:spaceCat];
    
    [self setupSounds];
    [self.backgroundMusic play];
}

- (void) setupSounds {
    NSURL *backgroundMusicUrl = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@".mp3"];
    
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicUrl error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic prepareToPlay];
    
    NSURL *gameOverMusicUrl = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@".mp3"];
    
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverMusicUrl error:nil];
    self.gameOverMusic.numberOfLoops = 1;
    [self.gameOverMusic prepareToPlay];
    
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.gameOver) {
        for (UITouch *touch in touches) {
            CGPoint position = [touch locationInNode:self];
            [self shootProjectileAtPosition:position];
        }
    } else if (self.restart) {
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        
        GameScene *scene = [GameScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}

- (void) shootProjectileAtPosition:(CGPoint)position {
    [spaceCat performTap];
    
    ProjectileNode *projectile = [ProjectileNode projectileWithName:ProjectileName];
    CGPoint projectilePosition = CGPointMake(machine.position.x,
                                             machine.frame.size.height - projectile.frame.size.height / 2);
    projectile.position = projectilePosition;
    
    [self addChild:projectile];
    [projectile moveTowardsPosition:position];
    
    [self runAction:self.laserSFX];
}

- (void) didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == CollisionCategoryEnemy
        && secondBody.categoryBitMask == CollisionCategoryProjectile) {
        
        SpaceDogNode *spaceDog = (SpaceDogNode *)firstBody.node;
        ProjectileNode *projectile = (ProjectileNode *)secondBody.node;
        
        spaceDog.health -= projectile.damage;
        
        if (spaceDog.health <= 0) {
            [spaceDog removeFromParent];
            [self createDebrisAtPosition:contact.contactPoint];
            [self runAction:self.explodeSFX];
            [self addPoints];
            
        } else if (spaceDog.health / 2 <= projectile.damage) {
            [spaceDog removeActionForKey:@"animation"];
            
            if (spaceDog.type == SpaceDogTypeA) {
                spaceDog.texture = [SKTexture textureWithImageNamed:@"spacedog_A_3"];
            } else {
                spaceDog.texture = [SKTexture textureWithImageNamed:@"spacedog_B_4"];
            }
        }
        
        [projectile removeFromParent];
        
    } else if (firstBody.categoryBitMask == CollisionCategoryEnemy
               && secondBody.categoryBitMask == CollisionCategoryGround) {
        
        SpaceDogNode *spaceDog = (SpaceDogNode *)firstBody.node;
        [spaceDog removeFromParent];
        
        [self runAction:self.damageSFX];
        [self createDebrisAtPosition:contact.contactPoint];
        
        [self loseLife];
    }
}

- (void) createDebrisAtPosition:(CGPoint)position {
    NSInteger numberOfPieces = [Util randomWithMin:MinDebrisPieces max:MaxDebrisPieces];
    
    for (int i = 0; i < numberOfPieces; i++) {
        NSInteger imageNumber = [Util randomWithMin:1 max:3];
        NSString *imageName = [NSString stringWithFormat:@"debri_%ld", imageNumber];
        
        SKSpriteNode *debri = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debri.position = position;
        debri.name = debriName;
        
        debri.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debri.frame.size];
        debri.physicsBody.categoryBitMask = CollisionCategoryDebri;
        debri.physicsBody.contactTestBitMask = 0;
        debri.physicsBody.collisionBitMask = CollisionCategoryGround | CollisionCategoryDebri;
        
        debri.physicsBody.velocity = CGVectorMake([Util randomWithMin:-150 max:150],
                                                  [Util randomWithMin:150 max:350]);
        
        [debri runAction:[SKAction waitForDuration:1.5] completion:^{
            [debri removeFromParent];
        }];
        
        [self addChild:debri];
        
        NSString *explosionFilePath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
        SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionFilePath];
        explosion.position = position;
        explosion.zPosition = 1;
        
        [self addChild:explosion];
        
        [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
            [explosion removeFromParent];
        }]; 
    }
}

- (void) addSpaceDog {
    NSUInteger spaceDogType = [Util randomWithMin:0 max:1];
    SpaceDogNode *spaceDog = [SpaceDogNode spaceDogWithType:spaceDogType];
    
    float dy = [Util randomWithMin:self.enemyMinSpeed max:SpaceDogMaxSpeed];
    spaceDog.physicsBody.velocity = CGVectorMake(0, dy);
    
    float y = self.frame.size.height + spaceDog.size.height;
    float x = [Util randomWithMin:SpawnMargin + spaceDog.size.width / 2
                              max:self.frame.size.width - spaceDog.size.width / 2 - SpawnMargin];
    
    spaceDog.position = CGPointMake(x, y);
    [self addChild:spaceDog];
}

- (void) addPoints {
    HudNode *hud = (HudNode *)[self childNodeWithName:HudName];
    [hud addPoints:PointsPerKill];
}

- (void) loseLife {
    HudNode *hud = (HudNode *)[self childNodeWithName:HudName];
    self.gameOver = [hud loseLife];
}

- (void) performGameOver {
    CGPoint gameOverPosition = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    GameOverNode *gameOver = [GameOverNode gameOverAtPosition:gameOverPosition];
    [self addChild:gameOver];
    
    [gameOver performAnimationWithScene:self];
    self.gameOverDispayed = YES;
    
    [self.backgroundMusic stop];
    [self.gameOverMusic play];
}

- (void) update:(CFTimeInterval)currentTime {
    if (self.lastUpdateTimeInterval) {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    
    if (self.timeSinceEnemyAdded > self.enemySpawnTimeInterval && !self.gameOver) {
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    
    if (self.totalGameTime >= GameTime10Minutes) {
        self.enemySpawnTimeInterval = 0.5;
        self.enemyMinSpeed = -180;
    } else if (self.totalGameTime >= GameTime6Minutes) {
        self.enemySpawnTimeInterval = 0.6;
        self.enemyMinSpeed = -170;
    } else if (self.totalGameTime >= GameTime4Minutes) {
        self.enemySpawnTimeInterval = 0.7;
        self.enemyMinSpeed = -160;
    } else if (self.totalGameTime >= GameTime2Minutes) {
        self.enemySpawnTimeInterval = 0.8;
        self.enemyMinSpeed = -150;
    } else if (self.totalGameTime >= GameTime1Minute) {
        self.enemySpawnTimeInterval = 0.9;
        self.enemyMinSpeed = -140;
    } else if (self.totalGameTime > GameTime20Seconds) {
        self.enemySpawnTimeInterval = 1.0;
        self.enemyMinSpeed = -130;
    }
    
    if (self.gameOver && !self.gameOverDispayed) {
        [self performGameOver];
    }
    
    self.lastUpdateTimeInterval = currentTime;
}

@end