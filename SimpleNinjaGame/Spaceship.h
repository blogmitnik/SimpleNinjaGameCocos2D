//
//  Spaceship.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/4/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h" 
#import "GameObject.h"
#import "MusicHandler.h" 
#import "ExplosionParticle.h"

@class HelloWorld;
@class GameObject;

@interface Spaceship :GameObject {
	//int _curHp;
	//int _maxHp;
	CCSprite *sprite;
	CCParticleMeteor *laser;
	CCLayer *layer;
	CCParticleSmoke *smoke;
	BOOL isImmortal;
	BOOL isDead;
	ExplosionParticle *stars;
	float movementSpeed;
}

-(void) move:(CGPoint) location; 
-(void) fire; 
-(void) destroyLaser; 
-(void) hit; 
-(void) damage; 
-(void) generateSmoke; 
-(void) destroy;
-(Spaceship *) initWithSpriteFileName:(NSString *)imagePath currentLayer:(CCLayer *)l theGame:(HelloWorld *)game;

//@property(nonatomic,assign) int hp;
//@property (nonatomic,readwrite) int maxHp;
@property (nonatomic,retain) CCSprite *sprite; 
@property (nonatomic,retain) CCParticleMeteor *laser; 
@property (nonatomic,retain) CCLayer *layer; 
@property (nonatomic,retain) CCParticleSmoke *smoke;
@property (nonatomic,retain) CCParticleFire *explosion; 
@property (nonatomic,assign) BOOL isImmortal; 
@property (nonatomic,assign) BOOL isDead;
@property (nonatomic, retain) ExplosionParticle *stars;
@property (nonatomic,readwrite) float movementSpeed;


@end