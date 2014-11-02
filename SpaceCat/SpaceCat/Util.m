//
//  Util.m
//  SpaceCat
//
//  Created by Nikola Bozhkov on 11/1/14.
//
//

#import "Util.h"

@implementation Util

+ (NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random() % (max - min + 1) + min;
}

@end
