//
//  CannonBall.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CannonBall.h"
#import "SimpleAudioEngine.h"

@implementation CannonBall

@synthesize _monstersHit,fired,whoFired,firingSpeed,lastHeroPos;

- (CannonBall*)initWithFile:(NSString *)file {
    if ((self = [super initWithFile:file])) {
        self._monstersHit = [NSMutableArray array];
    }
    return self;
}

- (BOOL)shouldDamageMonster:(CCSprite *)monster {
    if ([_monstersHit containsObject:monster]) {
        return FALSE;
    }
    else {
        [_monstersHit addObject:monster];
        return TRUE;
    }
}

-(void)takeFire {
	CGPoint diff = ccpSub(self.lastHeroPos,self.position);
	float speedY = ((float)diff.y / (float)diff.x) * self.firingSpeed;
	
	switch (self.whoFired) {
		case 1:
			[self setPosition:ccp(self.position.x-self.firingSpeed ,self.position.y)];
			break;
		case 2:
			[self setPosition:ccp(self.position.x-self.firingSpeed ,self.position.y-speedY)];
			break;
	}
	if(self.position.x > 500 || self.position.x < -20) {
		[self reset];
	}
}

-(void)reset {
	self.fired = NO;
	[self setPosition:ccp(-100,-100)];
}

-(void)fire:(int)who position:(CGPoint)position target:(CGPoint)target fspeed:(int)fspeed {
	self.firingSpeed = fspeed;
	self.whoFired = who;
	self.fired = YES;
	self.position = position;
	self.lastHeroPos = target;
}

- (void)dealloc
{
    self._monstersHit = nil;    
    [super dealloc];
}

@end
