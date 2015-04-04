//
//  Demon.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/4/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "Demon.h"
#import "MusicHandler.h"

@implementation Demon

//@synthesize hp = _curHp;
//@synthesize curScore = _curScore;
@synthesize sprite,layer,fireball,isDead;

-(Demon *) initWithSpriteFileName1:(NSString *) imagePath currentLayer:(CCLayer *)l theGame:(HelloWorld *)game {
	self = [super init];
	self.sprite = [CCSprite spriteWithFile:imagePath];
	self.hp = 50 * game.difficulty;
	self.curScore = 10 * game.difficulty;
	self.layer = l;
	self.isDead = NO;
	return self;
}

-(void) hit {	
	self.isDead = YES;
	
	//Make demon hit animation 
	id rotate = [CCRotateBy actionWithDuration:0.5 angle:360];
	id changeColr = [CCSequence actions:
					 [CCTintTo actionWithDuration:0.3 red:255 green:0 blue:0], 
					 [CCTintTo actionWithDuration:0.2 red:255 green:255 blue:255], nil];
	id doAction = [CCSpawn actions:rotate, changeColr, nil];
	id callback = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
	
	[self.sprite runAction:[CCSequence actions:doAction,callback, nil]];
	//[self destroy];
}

-(void) destroy {
	CCParticleExplosion *explosion = [[CCParticleExplosion alloc] init]; 
	[explosion setTotalParticles:10];
	[explosion setAutoRemoveOnFinish:YES];
	[explosion setEndSize:-1];
	[explosion setLife:5];
	[explosion setDuration:1];
	explosion.position = self.sprite.position; 
	
	[self.layer addChild:explosion];
	[self.layer removeChild:self.sprite cleanup:YES];
	self.sprite = nil;
}

-(void) fire {
	[MusicHandler playDemonAttackMusic];
	
	if(fireball != nil) {
		[layer removeChild:fireball cleanup:YES];
		fireball = nil; 
	}
	
	fireball = [[CCParticleSun alloc] init]; 
	[fireball setStartSize:5];
	[fireball setAutoRemoveOnFinish:TRUE];
	
	fireball.position = sprite.position; 
	
	id moveToAction = [CCMoveTo actionWithDuration:2.0 position:ccp(sprite.position.x,-100)];
	id callback = [CCCallFunc actionWithTarget:self selector:@selector(fire)];
	
	[fireball runAction:[CCSequence actions:moveToAction,callback,nil]];
	[self.layer addChild:fireball z:2];
}

// make the demon move randomly on the screen
-(void) launch {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	int x = arc4random() % (int) winSize.width; 
	int y = arc4random() % (int) winSize.height;
	
	id moveAction = [CCMoveTo actionWithDuration:2.0 position:ccp(x,y)];
	id callback = [CCCallFunc actionWithTarget:self selector:@selector(launch)];
	
	[self.sprite runAction:[CCSequence actions:moveAction,callback,nil]];
	
	// start firing 
	[self fire]; 
}

@end
