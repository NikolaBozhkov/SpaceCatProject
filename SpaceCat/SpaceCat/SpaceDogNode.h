//
//  SpaceDogNode.h
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, SpaceDogType) {
    SpaceDogTypeA,
    SpaceDogTypeB
};

@interface SpaceDogNode : SKSpriteNode

+ (instancetype)spaceDogWithType:(SpaceDogType)type;

@property NSInteger health;
@property (readonly) SpaceDogType type;

@end
