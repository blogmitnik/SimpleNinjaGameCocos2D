//
//  Demon.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/4/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h" 
#import "GameObject.h"
#import "SimpleAudioEngine.h" 

@class HelloWorld;
@class GameObject;


@interface Demon : GameObject {	
	//int _curHp;
	//int _curScore;
	CCSprite *sprite;
	CCLayer *layer; 
	CCParticleSun *fireball; 
	BOOL isDead;
}

-(void) launch; 
-(void) fire; 
-(void) hit; 
-(void) destroy; 
-(Demon *) initWithSpriteFileName1:(NSString *)imagePath currentLayer:(CCLayer *)l theGame:(HelloWorld *)game;

//@property(nonatomic,assign) int hp;
//@property(nonatomic,assign) int curScore;
@property (nonatomic,retain) CCSprite *sprite; 
@property (nonatomic,retain) CCLayer *layer; 
@property (nonatomic,retain) CCParticleSun *fireball; 
@property (nonatomic,assign) BOOL isDead;

@end
