//
//  CollisionAttacker.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionAttacker.h"
#import "CannonBall.h"
#import "HelloWorldLayer.h"

@implementation CollisionAttacker

@synthesize hp = _curHp;
@synthesize curScore = _curScore;
@synthesize launched; //set it to "NO" below, if you don't want this to make fire
@synthesize lastTimeFired = _lastTimeFired;
@synthesize fireInterval = _fireInterval;
@synthesize firingSpeed = _firingSpeed;

-(void)launchFire:(HelloWorld *)game {
	HelloWorld *theGame = game;
	
	for(CannonBall *b in theGame._monsterKnife) {
		if(self.fireInterval > 0 && !b.fired && self.lastTimeFired > self.fireInterval)
		{
			//Rotate bullet to the corresponding angle
			CGPoint diff = ccpSub(theGame.spaceship.sprite.position,self.position);
			float angleRadians = atanf((float)diff.y / (float)diff.x);
			float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
			float cocosAngle = -1 * angleDegrees;
			if (diff.x < 0) {
				cocosAngle += 180;
			}
			b.rotation = cocosAngle;
			//The bullet fired!
			[b fire:2 position:self.position target:theGame.spaceship.sprite.position fspeed:self.firingSpeed];
			self.lastTimeFired = 0;
		}
	}
	self.lastTimeFired += 0.1;
}

@end

@implementation AGSystems
+(id)attacker {
	HelloWorld *theGame = [[[HelloWorld alloc]init] autorelease];
	AGSystems *attacker = nil;
    if ((attacker = [[[super alloc] initWithFile:@"AG Systems.png"] autorelease])) {
        attacker.hp = 10 + (theGame.difficulty * 2);
		attacker.curScore = 65 * theGame.difficulty;
		attacker.launched = YES;
		attacker.fireInterval = 7 - theGame.difficulty;
		attacker.lastTimeFired = 0;
		attacker.firingSpeed = 10 - theGame.difficulty;
    }
    return attacker;
}
@end

@implementation AuricomResearch
+(id)attacker {
	HelloWorld *theGame = [[[HelloWorld alloc]init] autorelease];
	AuricomResearch *attacker = nil;
    if ((attacker = [[[super alloc] initWithFile:@"Auricom Research.png"] autorelease])) {
        attacker.hp = 9 + (theGame.difficulty * 2);
		attacker.curScore =55 * theGame.difficulty;
		attacker.launched = YES;
		attacker.fireInterval = 6 - theGame.difficulty;
		attacker.lastTimeFired = 0;
		attacker.firingSpeed = 10 - theGame.difficulty;
    }
    return attacker;
}
@end

@implementation QirexRD
+(id)attacker {
	HelloWorld *theGame = [[[HelloWorld alloc]init] autorelease];
	QirexRD *attacker = nil;
    if ((attacker = [[[super alloc] initWithFile:@"Qirex RD.png"] autorelease])) {
        attacker.hp = 8 + (theGame.difficulty * 2);
		attacker.curScore = 45 * theGame.difficulty;
		attacker.launched = YES;
		attacker.fireInterval = 6 - theGame.difficulty;
		attacker.lastTimeFired = 0;
		attacker.firingSpeed = 9 - theGame.difficulty;
    }
    return attacker;
}
@end

@implementation PirhanaAdvancements
+(id)attacker {
	HelloWorld *theGame = [[[HelloWorld alloc]init] autorelease];
	PirhanaAdvancements *attacker = nil;
    if ((attacker = [[[super alloc] initWithFile:@"Pirhana Advancements.png"] autorelease])) {
        attacker.hp = 7 + (theGame.difficulty * 2);
		attacker.curScore = 35 * theGame.difficulty;
		attacker.launched = YES;
		attacker.fireInterval = 5 - theGame.difficulty;
		attacker.lastTimeFired = 0;
		attacker.firingSpeed = 8 - theGame.difficulty;
    }
    return attacker;
}
@end


@implementation FEISAR
+(id)attacker {
	HelloWorld *theGame = [[[HelloWorld alloc]init] autorelease];
	FEISAR *attacker = nil;
    if ((attacker = [[[super alloc] initWithFile:@"FEISAR.png"] autorelease])) {
        attacker.hp = 6 + (theGame.difficulty * 2);
		attacker.curScore = 30 * theGame.difficulty;
		attacker.launched = YES;
		attacker.fireInterval = 4 - theGame.difficulty;
		attacker.lastTimeFired = 0;
		attacker.firingSpeed = 9 - theGame.difficulty;
    }
    return attacker;
}
@end
