//
//  SpaceDogNode.m
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import "SpaceDogNode.h"
#import "Util.h"

@interface SpaceDogNode ()

@property SpaceDogType type;

@end

@implementation SpaceDogNode

+ (instancetype)spaceDogWithType:(SpaceDogType)type {
    SpaceDogNode *spaceDog;
    NSArray *textures;
    
    if (type == SpaceDogTypeA) {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
        spaceDog.type = SpaceDogTypeA;
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_A_2"]];
    } else {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
        spaceDog.type = SpaceDogTypeB;
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_3"]];
    }
    
    float scale = [Util randomWithMin:SpaceDogMinScale max:SpaceDogMaxScale] / 100.0f;
    spaceDog.xScale = scale;
    spaceDog.yScale = scale;
    
    spaceDog.health = SpaceDogHealth;
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [spaceDog runAction:[SKAction repeatActionForever:animation] withKey:@"animation"];
    
    [spaceDog setupPhysicsBody];
    
    return spaceDog;
}

- (void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryProjectile | CollisionCategoryGround;
}

@end
