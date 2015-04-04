//
//  CannonBall.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/3/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CannonBall : CCSprite {
	NSMutableArray *_monstersHit;
	bool fired;
	int whoFired;
	int firingSpeed;
	CGPoint lastHeroPos;
}

@property (nonatomic,retain) NSMutableArray *_monstersHit;
@property (nonatomic,readwrite) bool fired;
@property (nonatomic,readwrite) int whoFired;
@property (nonatomic,readwrite) int firingSpeed;
@property (nonatomic,readwrite) CGPoint lastHeroPos;

-(CannonBall *)initWithFile:(NSString *)file;
-(BOOL)shouldDamageMonster:(CCSprite *)monster;
-(void)fire:(int)who position:(CGPoint)position target:(CGPoint)target fspeed:(int)fspeed;
-(void)reset;

@end
