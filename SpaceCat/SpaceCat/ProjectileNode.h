//
//  ProjectileNode.h
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import <SpriteKit/SpriteKit.h>

@interface ProjectileNode : SKSpriteNode

+ (instancetype)projectileWithName:(NSString *)name;
+ (instancetype)projectileWithPosition:(CGPoint)position name:(NSString *)name;

@property NSInteger damage;

- (void)moveTowardsPosition:(CGPoint)position;

@end
