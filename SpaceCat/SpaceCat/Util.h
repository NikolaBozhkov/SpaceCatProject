//
//  Util.h
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import <Foundation/Foundation.h>

static const NSInteger Margin = 20;

static const NSInteger GroundHeight = 22;

static const NSInteger MachinePositionY = 12;

static const NSInteger ProjectileSpeed = 400;
static const NSInteger ProjectileDamage = 50;

static const NSInteger MinDebrisPieces = 7;
static const NSInteger MaxDebrisPieces = 20;

static const NSInteger SpaceDogHealth = 100;

static const NSInteger SpaceDogMinSpeed = -120;
static const NSInteger SpaceDogMaxSpeed = -50;

static const NSInteger SpaceDogMinScale = 80;
static const NSInteger SpaceDogMaxScale = 100;

static const NSInteger SpawnMargin = 10;

static const NSTimeInterval EnemyInitialSpawnTimeInterval = 1.2;

static const NSInteger MaxLives = 4;
static const NSInteger PointsPerKill = 50;

static const NSTimeInterval GameTime20Seconds = 20;
static const NSTimeInterval GameTime1Minute = 60;
static const NSTimeInterval GameTime2Minutes = 120;
static const NSTimeInterval GameTime4Minutes = 240;
static const NSTimeInterval GameTime6Minutes = 480;
static const NSTimeInterval GameTime10Minutes = 720;

static NSString *GameOverLabelName = @"GameOver";
static NSString *GameOverLabelText = @"Game Over";
static const NSInteger GameOverLabelFontSize = 48;

static NSString *HudName = @"Hud";
static NSString *ScoreLabelName = @"Score";
static NSString *GroundName = @"Ground";
static NSString *ProjectileName = @"Projectile";
static NSString *debriName = @"Debri";

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryEnemy = 1 << 0,
    CollisionCategoryGround = 1 << 1,
    CollisionCategoryProjectile = 1 << 2,
    CollisionCategoryDebri = 1 << 3
};

@interface Util : NSObject

+ (NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
