//
//  Spaceship.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/4/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "Spaceship.h"

@implementation Spaceship

//@synthesize hp = _curHp;
//@synthesize maxHp = _maxHp;
@synthesize sprite,laser,layer,smoke,explosion,isImmortal,isDead,stars,movementSpeed;

-(Spaceship *) initWithSpriteFileName:(NSString *)imagePath currentLayer:(CCLayer *)l theGame:(HelloWorld *)game
{
	self = [super init];	
	self.sprite = [CCSprite spriteWithSpriteFrameName:imagePath];
	self.hp = self.maxHp = 5 * game.difficulty;
	self.movementSpeed = 5;
	self.layer = l; 
	self.isImmortal = YES; 
	self.isDead = NO;
	
	// add a blink effect for immortality
	[self.sprite runAction:[CCBlink actionWithDuration:3.0 blinks:10]];
	// make the space ship mortal after 4 seconds
	[self performSelector:@selector(makeMortal) withObject:nil afterDelay:4.0];
	
	return self; 
}

-(Spaceship *) init {
	self = [super init]; 
	return self; 
}

-(void) makeMortal {
	self.isImmortal = NO; 
}

-(void) damage {
	self.hp -= 1;
	[self.sprite runAction:[CCSequence actions:
						[CCTintTo actionWithDuration:0.1 red:255 green:0 blue:0], 
						[CCTintTo actionWithDuration:0.1 red:255 green:255 blue:255], nil]];
	[MusicHandler playDamageMusic];
	if (self.hp <= 0) {
		[self hit];
		self.hp = self.maxHp;
	}
}

-(void) hit {	
	self.isDead = YES;
	
	//Make explosion sound effect
	[MusicHandler playHugeExplosionMusic];
	
	id changeColr = [CCSequence actions:
					 [CCTintTo actionWithDuration:0.3 red:255 green:0 blue:0], 
					 [CCTintTo actionWithDuration:0.2 red:255 green:255 blue:255], nil];
	id callback = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
	
	[self.sprite runAction:[CCSequence actions:changeColr,callback,nil]];
	[self destroy];
}

-(void) destroy {
	stars = [ExplosionParticle node];
	[stars setPosition:self.sprite.position];
	[stars runAction:[CCMoveBy actionWithDuration:1 position:ccp(0,-100)]];
	[self.layer addChild:stars z:5];
	
	explosion = [[CCParticleFire alloc] init]; 
	[explosion setTotalParticles:10];
	[explosion setAutoRemoveOnFinish:YES];
	[explosion setLife:5];
	[explosion setDuration:1];
	[explosion setEndSize:-1];
	
	explosion.position = self.sprite.position; 
	[self.layer addChild:explosion]; 
	
	// kill the space ship 
	[self.sprite removeFromParentAndCleanup:YES];
	//[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	
	self.sprite = nil; 
	
}

-(void) generateSmoke {
	smoke = [[CCParticleFire alloc] init];
	[smoke setTotalParticles:10];
	smoke.position = ccp(self.sprite.position.x, smoke.contentSize.height); 
	[smoke setGravity:ccp(0, 150)];
	[self.layer addChild:smoke]; 
}

-(void) destroyLaser {
	[self.layer removeChild:self.laser cleanup:YES]; 
	self.laser = nil; 
}

-(void) fire {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	[MusicHandler playLaserMusic];
	
	self.laser = [[CCParticleMeteor alloc] init];
	[self.laser setStartSize:-99];
	
	self.laser.position = ccp(self.sprite.position.x,self.sprite.position.y);
	[self.laser setGravity:ccp(0,0)];
	
	[self.laser setStartSize:10];
	
	id moveAction = [CCMoveTo actionWithDuration:1.0 position:ccp(winSize.width + 300, self.sprite.position.y)]; 
	id moveActionDone = [CCCallFunc actionWithTarget:self selector:@selector(destroyLaser)];
	
	[self.laser runAction:[CCSequence actions:moveAction,moveActionDone,nil]];
	[self.layer addChild:self.laser];
}

-(void) move:(CGPoint)location {
	id moveToAction = [CCMoveTo	actionWithDuration:0.5 position:ccp(location.x,sprite.position.y)];
	
	[self.sprite runAction:moveToAction];
}

@end
