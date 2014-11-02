//
//  HudNode.m
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/2/14.
//
//

#import "HudNode.h"
#import "Util.h"

@implementation HudNode

+ (instancetype)hudAtPosition:(CGPoint)position withFrame:(CGRect)frame {
    HudNode *hud = [self node];
    hud.name = HudName;
    hud.position = position;
    hud.zPosition = 10;
    
    SKSpriteNode *catHead = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_cat_1"];
    catHead.position = CGPointMake(catHead.frame.size.width / 2 + Margin, -10);
    [hud addChild:catHead];
    
    hud.lives = MaxLives;
    hud.score = 0;
    
    CGPoint lastLifePosition;
    
    for (int i = 0; i < hud.lives; i++) {
        SKSpriteNode *lifeNode = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_life_1"];
        lifeNode.name = [NSString stringWithFormat:@"Life_%d", i];
        
        if (i == 0) {
            lastLifePosition = CGPointMake(catHead.position.x + Margin  * 1.5, catHead.position.y);
            lifeNode.position = lastLifePosition;
        } else {
            lifeNode.position = CGPointMake(lastLifePosition.x + Margin / 2, lastLifePosition.y);
        }
        
        [hud addChild:lifeNode];
        lastLifePosition = lifeNode.position;
    }
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    scoreLabel.name = ScoreLabelName;
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 24;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.position = CGPointMake(frame.size.width - Margin, catHead.position.y);
    [hud addChild:scoreLabel];
    
    return hud;
}

- (void) addPoints:(NSInteger) points {
    self.score += points;
    
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:ScoreLabelName];
    scoreLabel.text = [NSString stringWithFormat:@"%ld", self.score];
}

- (BOOL) loseLife {
    self.lives--;
    
    NSString *lifeNodeName = [NSString stringWithFormat:@"Life_%ld", self.lives];
    SKSpriteNode *life = (SKSpriteNode *)[self childNodeWithName:lifeNodeName];
    [life removeFromParent];
    
    return self.lives <= 0;
}

@end
