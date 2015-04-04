//
//  Level.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Level.h"

@implementation Level

@synthesize _spawnRate;
@synthesize _levelNum;
@synthesize _levelScore;
@synthesize _bgImageName;
@synthesize _frontBgName;
@synthesize _bgmName;
@synthesize _levelName;
@synthesize _levelDoneBg;

- (id)initWithLevelNum:(int)levelNum spawnRate:(float)spawnRate levelScore:(int)levelScore bgImageName:(NSString *)bgImageName frontBgName:(NSString *)frontBgName bgmName:(NSString *)bgmName levelName:(NSString *)levelName levelDoneBg:(NSString *)levelDoneBg 
{
    if ((self = [super init])) {
        self._levelNum = levelNum;
        self._spawnRate = spawnRate;
		self._levelScore = levelScore;
        self._bgImageName = bgImageName;
		self._frontBgName = frontBgName;
		self._bgmName = bgmName;
		self._levelName = levelName;
		self._levelDoneBg = levelDoneBg;
    }
    return self;
}

@end
