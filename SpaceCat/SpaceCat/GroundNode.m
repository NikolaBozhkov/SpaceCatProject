//
//  GroundNode.m
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import "GroundNode.h"
#import "Util.h"

@implementation GroundNode

+ (instancetype)groundWithSize:(CGSize)size {
    GroundNode *ground = [self spriteNodeWithColor:[SKColor clearColor] size:size];
    ground.name = GroundName;
    
    ground.position = CGPointMake(size.width / 2, size.height / 2);
    [ground setupPhysicsBody];
    
    return ground;
}

- (void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryGround;
    self.physicsBody.collisionBitMask = CollisionCategoryDebri;
}

@end
