//
//  SpaceCatNode.m
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import "SpaceCatNode.h"

@interface SpaceCatNode ()

@property (nonatomic) SKAction *tapAction;

@end

@implementation SpaceCatNode

+ (instancetype)spaceCatWithPosition:(CGPoint)position {
    SpaceCatNode *spaceCat = [self spriteNodeWithImageNamed:@"spacecat_1"];
    spaceCat.anchorPoint = CGPointMake(0.5, 0);
    spaceCat.zPosition = 9;
    spaceCat.position = position;
    
    return spaceCat;
}

- (void)performTap {
    [self runAction:self.tapAction];
}

- (SKAction *)tapAction {
    if (_tapAction != nil) {
        return _tapAction;
    }
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"spacecat_2"],
                          [SKTexture textureWithImageNamed:@"spacecat_1"]];
    
    _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.2];
    return _tapAction;
}

@end
