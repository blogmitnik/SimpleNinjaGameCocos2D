//
//  ObjectFactory.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/5/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionFactory.h"
#import "ObjectFactory.h"
#import "GameObject.h"
#import "HelloWorldLayer.h"
#import "CannonBall.h"

@interface Enemy : GameObject {
    int fireFrames;
    int fireInterval;
	float fireInterval2;
	float lastTimeFired;
	float firingSpeed;
}
@property (nonatomic,readwrite) int fireFrames;
@property (nonatomic,readwrite) int fireInterval;
@property (nonatomic,readwrite) float fireInterval2;
@property (nonatomic,readwrite) float lastTimeFired;
@property (nonatomic,readwrite) float firingSpeed;

@end


@implementation Enemy

@synthesize fireFrames;
@synthesize fireInterval;
@synthesize fireInterval2;
@synthesize lastTimeFired;
@synthesize firingSpeed;

//Make some 3 bullet enemy's property
- (void)initGameObject
{
	[super initGameObject];
	
	// Initialize properties
    self.maxLife = 30;
    self.life = self.maxLife;
    self.damage = 1;
    self.owner = kGameObjectOwnerEnemy;
	self.hp = self.maxHp = 30;
	self.curScore = 60;
	self.launched = YES; //Change to 'NO', if you don't want to fire CannonBall
    
    fireInterval = 60; //Fire interval for 3 bullets
	fireInterval2 = 4; //Fire interval for CannonBall fire
    fireFrames = fireInterval - 5;
	lastTimeFired = 0;
	firingSpeed = 10;
}

-(void)launchFire:(HelloWorld *)game {
	HelloWorld *theGame = game;
	
	for(CannonBall *b in theGame._monsterKnife) {
		if(self.fireInterval2 > 0 && !b.fired && self.lastTimeFired > self.fireInterval2)
		{
			[b fire:1 position:self.position target:theGame.spaceship.sprite.position fspeed:self.firingSpeed];
			self.lastTimeFired = 0;
			//[MusicHandler playMonsterAttackMusic];
		}
	}
	self.lastTimeFired += 0.1;
}

- (void)mainPhase:(ccTime)dt
{
    HelloWorld *theGame = self.theGame;
	GameObject *player = theGame.player;
    
    //Shoot 3 bullets to the target at same time!
    if (fireFrames++ > fireInterval)
    {
		fireFrames = 0;
        GameObject *bullet1 = [ObjectFactory bullet];
        bullet1.position = self.position;
        CCAction *action1 = [ActionFactory moveByFrom:bullet1.position 
												   to:player.position
												  speed:100*theGame.difficulty];
        [bullet1 runAction:action1];
        [theGame addChild:bullet1 z:2];
        
        GameObject *bullet2 = [ObjectFactory bullet];
        bullet2.position = self.position;
        CCAction *action2 = [ActionFactory moveByFrom:bullet2.position 
													 to:player.position 
												 degree:5
												  speed:100*theGame.difficulty];
        [bullet2 runAction:action2];
        [theGame addChild:bullet2 z:2];
        
        GameObject *bullet3 = [ObjectFactory bullet];
        bullet3.position = self.position;
        CCAction *action3 = [ActionFactory moveByFrom:bullet3.position
													 to:player.position
												 degree:-5
												  speed:100*theGame.difficulty];
        [bullet3 runAction:action3];
        [theGame addChild:bullet3 z:2];
    }
}

@end


@implementation ObjectFactory

+(GameObject *)enemy
{
    GameObject *object = [Enemy spriteWithFile:@"devil.png"];
    return object;
}

+(GameObject *)bullet
{
    GameObject *object = [GameObject spriteWithFile:@"bullet3.png"];
    object.maxLife = 1;
    object.life = object.maxLife;
    object.damage = 2;
    object.owner = kGameObjectOwnerEnemy;
    return object;
}

@end