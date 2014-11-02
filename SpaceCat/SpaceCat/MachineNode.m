//
//  MachineNode.m
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import "MachineNode.h"

@implementation MachineNode

+ (instancetype)machineWithPosition:(CGPoint)position {
    MachineNode *machine = [self spriteNodeWithImageNamed:@"machine_1"];
    machine.anchorPoint = CGPointMake(0.5, 0);
    machine.zPosition = 8;
    machine.position = position;
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"machine_1"],
                          [SKTexture textureWithImageNamed:@"machine_2"]];
    
    SKAction *machineAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    SKAction *machineRepeat = [SKAction repeatActionForever:machineAnimation];
    [machine runAction:machineRepeat];
    
    return machine;
}

@end
