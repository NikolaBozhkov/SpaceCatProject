//
//  HudNode.h
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/2/14.
//
//

#import <SpriteKit/SpriteKit.h>

@interface HudNode : SKNode

+ (instancetype) hudAtPosition:(CGPoint)position withFrame:(CGRect)frame;

@property NSInteger lives;
@property NSInteger score;

- (void) addPoints:(NSInteger)points;
- (BOOL) loseLife;

@end
