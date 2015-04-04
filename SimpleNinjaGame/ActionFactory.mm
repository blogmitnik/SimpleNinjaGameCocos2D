//
//  ActionFactory.m
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/5/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionFactory.h"


@implementation ActionFactory

+(CCAction *)moveByFrom:(CGPoint)from to:(CGPoint)to inSecond:(ccTime)second
{
    CGPoint targetPosition = ccp((to.x-from.x)*(ACTION_DURATION/second), (to.y-from.y)*(ACTION_DURATION/second));
    CCAction *action = [CCMoveBy actionWithDuration:ACTION_DURATION position:targetPosition];
    return action;
}

+(CCAction *)moveByFrom:(CGPoint)from to:(CGPoint)to speed:(float)speed
{
    return [ActionFactory moveByFrom:from to:to degree:0 speed:speed];
}

+(CCAction *)moveByFrom:(CGPoint)from to:(CGPoint)to degree:(float)degree speed:(float)speed
{
    float radianTo = ccpToAngle(ccp(to.x - from.x, to.y - from.y));
    return [ActionFactory moveByFrom:from degree:CC_RADIANS_TO_DEGREES(radianTo)+degree speed:speed];
}

+(CCAction *)moveByFrom:(CGPoint)from degree:(float)degree speed:(float)speed
{
    float dx = speed * cosf(CC_DEGREES_TO_RADIANS(degree)) * ACTION_DURATION;
    float dy = speed * sinf(CC_DEGREES_TO_RADIANS(degree)) * ACTION_DURATION;
    CGPoint targetPosition = ccp(dx, dy);
    CCAction *action = [CCMoveBy actionWithDuration:ACTION_DURATION position:targetPosition];
    return action;
}

+(CCAction *)moveByFrom:(CGPoint)from acceleration:(UIAcceleration *)acceleration
{
    CGPoint targetPosition = ccp(from.x, from.y);
    if (acceleration.x > 0.2) {
        targetPosition.x += 100 * ACTION_DURATION;
    } 
	else if(acceleration.x < -0.2) {
        targetPosition.x -= 100 * ACTION_DURATION;
    }
    
    if (acceleration.y > 0.15) {
        targetPosition.y += 100 * ACTION_DURATION;
    }
    else if(acceleration.y < -0.15) {
        targetPosition.y -= 100 * ACTION_DURATION;
    }
    
    CCAction *action = [CCMoveBy actionWithDuration:ACTION_DURATION position:targetPosition];
    return action;
}


@end
