//
//  SpaceCatNode.h
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import <SpriteKit/SpriteKit.h>

@interface SpaceCatNode : SKSpriteNode

+ (instancetype)spaceCatWithPosition:(CGPoint)position;

- (void)performTap;

@end
