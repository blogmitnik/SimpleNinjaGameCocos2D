//
//  Monster.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Monster.h"
#import "HelloWorldLayer.h"
#import "CannonBall.h"
#import "MusicHandler.h"

@implementation Monster

@synthesize hp = _curHp;
@synthesize maxHp = _maxHp;
@synthesize curScore = _curScore;
@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;
@synthesize launched; //set it to "NO" below, if you don't want this to make fire
@synthesize lastTimeFired = _lastTimeFired;
@synthesize fireInterval = _fireInterval;
@synthesize firingSpeed = _firingSpeed;

-(void)launchFire:(HelloWorld *)game {
	HelloWorld *theGame = game;
	
	for(CannonBall *b in theGame._monsterKnife) {
		if(self.fireInterval > 0 && !b.fired && self.lastTimeFired > self.fireInterval)
		{
			[b fire:1 position:self.position target:theGame.spaceship.sprite.position fspeed:self.firingSpeed];
			self.lastTimeFired = 0;
			[MusicHandler playMonsterAttackMusic];
		}
	}
	self.lastTimeFired += 0.1;
}

@end


@implementation WeakAndFastMonster

+ (id)monster {
	HelloWorld *theGame = [[[HelloWorld alloc]init] autorelease];
    WeakAndFastMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"ghost1.png"] autorelease])) {
        monster.hp = monster.maxHp = 1 + (theGame.difficulty * 2);
		monster.curScore = 10 * theGame.difficulty;
        monster.minMoveDuration = 5;
        monster.maxMoveDuration = 8;
		monster.launched = YES;
		monster.fireInterval = 4 - theGame.difficulty;
		monster.lastTimeFired = 0;
		monster.firingSpeed = 10 + theGame.difficulty;
    }
    return monster;
}

@end


@implementation StrongAndSlowMonster

+ (id)monster {
	HelloWorld *theGame = [[[HelloWorld alloc]init] autorelease];
    StrongAndSlowMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"ghost2.png"] autorelease])) {
        monster.hp = monster.maxHp = 3 + (theGame.difficulty * 2);
		monster.curScore = 20 * theGame.difficulty;
        monster.minMoveDuration = 7;
        monster.maxMoveDuration = 12;
		monster.launched = YES;
		monster.fireInterval = 6 - theGame.difficulty;
		monster.lastTimeFired = 0;
		monster.firingSpeed = 7 + theGame.difficulty;
    }
    return monster;
}

@end


@implementation StrongAndFastMonster

+ (id)monster {
	HelloWorld *theGame = [[[HelloWorld alloc]init] autorelease];
    StrongAndSlowMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"ghost3.png"] autorelease])) {
        monster.hp = monster.maxHp = 5 + (theGame.difficulty * 2);
		monster.curScore = 30 * theGame.difficulty;
        monster.minMoveDuration = 5;
        monster.maxMoveDuration = 9;
		monster.launched = YES;
		monster.fireInterval = 8 - theGame.difficulty;
		monster.lastTimeFired = 0;
		monster.firingSpeed = 8 + theGame.difficulty;
    }
    return monster;
}

@end

