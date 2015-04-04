//
//  CollisionManager.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/4/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionManager.h"


@implementation CollisionManager

-(BOOL) isCollided:(CCNode *)source objectUnderCollision:(CCNode *)target
{
	
	float distance = powf(source.position.x - target.position.x, 2) + powf(source.position.y - target.position.y, 2); 
	distance = sqrtf(distance);
	NSLog(@"collide distance:%d", distance);
	
	if(distance <= target.contentSize.width/2)
		return YES;
	
	return NO;
	
}

@end
