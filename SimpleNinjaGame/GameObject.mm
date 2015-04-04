//
//  GameObject.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/5/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import "HelloWorldLayer.h"
#import "MusicHandler.h"

@implementation GameObject

@synthesize owner;
@synthesize maxLife;
@synthesize life;
@synthesize damage;
@synthesize theGame;
@synthesize hp = _curHp;
@synthesize maxHp = _maxHp;
@synthesize curScore = _curScore;
@synthesize launched;


-(void)initGameObject
{
    [self schedule:@selector(onFrame:)];
    // Initialize properties
    self.maxLife = 0;
    self.life = self.maxLife;
    self.damage = 0;
}

-(id)initWithFile:(NSString *)imageFile
{
    if(self = [super initWithFile:imageFile])
    {
        [self initGameObject];
    }
    return self;
}

-(id)initWithCGImage:(CGImageRef)image
{
    if(self = [super initWithCGImage:image]) {
        [self initGameObject];
    }
    return self;
}

-(id)initWithTexture:(CCTexture2D*)tex
{
    if(self = [super initWithTexture:tex]) {
        [self initGameObject];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)onFrame:(ccTime)dt
{
    //1. Main phase
    [self mainPhase:dt];
    
    //2. HitTest phase
    GameObject *targetHitPlayer = [self hitTestPhase:dt];
    
    //3. Cleanup phase
    [self cleanupPhase];
    if (targetHitPlayer) {
        [targetHitPlayer cleanupPhase];
    }
}

-(void)mainPhase:(ccTime)dt
{
    // Do nothing, override this method for each objects
}

-(GameObject *)hitTestPhase:(ccTime)dt
{
	HelloWorld *gameLayer = self.theGame;
	GameObject *player = gameLayer.player;
	
	// List all children in GameObject
    for (id node in self.parent.children) {
        if ([node isKindOfClass:[GameObject class]])
        {
            GameObject *target = (GameObject *)node;
			
            // Don't hit check if player is currently invulnerable
            if (gameLayer.spaceship.isImmortal || gameLayer.spaceship.isDead) {
                continue;
            }
			// Don't hit check if target is not foe
            //else if (target.owner == kGameObjectOwnerWorld || target.owner == kGameObjectOwnerEnemy || target.owner == self.owner) {
			//	continue;
            //}
			
			if([self isCollided:target objectUnderCollision:player]) 
			{
				[MusicHandler playDamageMusic];
				gameLayer.spaceship.hp -= target.damage;
				target.life -= self.damage;
				NSLog(@"remain hp:%i", gameLayer.spaceship.hp);
				NSLog(@"target life:%i", target.life);
				[player runAction:[CCSequence actions:
												  [CCTintTo actionWithDuration:0.1 red:255 green:0 blue:0], 
												  [CCTintTo actionWithDuration:0.1 red:255 green:255 blue:255], nil]];
				if (gameLayer.spaceship.hp <= 0) {
					[gameLayer removeLifeByTag:gameLayer.lives];
					gameLayer.lives -= 1; 
					[gameLayer.spaceship hit];
					[gameLayer performSelector:@selector(addSpaceshipToGame) withObject:nil afterDelay:1.0];
					[gameLayer.livesCount setString:[NSString stringWithFormat:@"X%d", gameLayer.lives]];
					gameLayer.spaceship.hp = gameLayer.spaceship.maxHp;
				}
				return target;
			}
        }
    }
    // Didnt't hit any targets, return nil
    return nil;
}

-(BOOL)isCollided:(GameObject *)source objectUnderCollision:(GameObject *)target
{
	float distance = powf(source.position.x - target.position.x, 2) + powf(source.position.y - target.position.y, 2); 
	distance = sqrtf(distance);
	NSLog(@"source owner:%i", source.owner);
	NSLog(@"collide distance:%f", distance);
	
	//The distance depends on spaceship's size
	if(distance <= 37)
		return YES;
		
	return NO;
	
}

-(void)cleanupPhase
{
    // Kill this object when life goes zero
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    if (self.life <= 0)
    {
        [self.parent removeChild:self cleanup:YES];
    }
	// Kill this object when out-of-bound
    else if (self.position.x + self.contentSize.width < 0
             || self.position.x - self.contentSize.width > winSize.width
             || self.position.y + self.contentSize.height < 0
             || self.position.y - self.contentSize.height > winSize.height)
    {
        [self.parent removeChild:self cleanup:YES];
    }
}

-(HelloWorld *)theGame
{
    return (HelloWorld *)self.parent;
}

@end
