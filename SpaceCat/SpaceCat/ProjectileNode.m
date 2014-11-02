//
//  ProjectileNode.m
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import "ProjectileNode.h"
#import "Util.h"

@implementation ProjectileNode

+ (instancetype)projectileWithName:(NSString *)name {
    ProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
    projectile.name = name;
    projectile.damage = ProjectileDamage;
    
    [projectile setupAction];
    [projectile setupPhysicsBody];
    
    return projectile;
}

+ (instancetype)projectileWithPosition:(CGPoint)position name:(NSString *)name {
    ProjectileNode *projectile = [ProjectileNode projectileWithName:name];
    projectile.position = position;
    
    return projectile;
}

- (void)setupAction {
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"projectile_1"],
                          [SKTexture textureWithImageNamed:@"projectile_2"],
                          [SKTexture textureWithImageNamed:@"projectile_3"]];
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *repeatAction = [SKAction repeatActionForever:animation];
    
    [self runAction:repeatAction];
}

- (void)moveTowardsPosition:(CGPoint)position {
    float slope = (position.y - self.position.y) / (position.x - self.position.x);
    
    float offScreenX;
    if (position.x <= self.position.x) {
        offScreenX = -10;
    } else {
        offScreenX = self.parent.frame.size.width + 10;
    }
    
    float offScreenY = slope * (offScreenX - self.position.x) + self.position.y;
    
    CGPoint pointOffScreen = CGPointMake(offScreenX, offScreenY);
    
    float distanceX = pointOffScreen.x - self.position.x;
    float distanceY = pointOffScreen.y - self.position.y;
    float distance = sqrtf(powf(distanceX, 2) + powf(distanceY, 2));
    
    float time = distance / ProjectileSpeed;
    float waitTime = time * 0.75;
    float fadeTime = time - waitTime;
    
    SKAction *moveAction = [SKAction moveTo:pointOffScreen duration:time];
    [self runAction:moveAction];
    
    NSArray *sequence = @[[SKAction waitForDuration:waitTime],
                          [SKAction fadeOutWithDuration:fadeTime],
                          [SKAction removeFromParent]];
    
    [self runAction:[SKAction sequence:sequence]];
}

- (void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryEnemy;
}

@end
