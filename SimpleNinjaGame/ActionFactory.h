//
//  ActionFactory.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/5/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"


#define ACTION_DURATION 10000.0f

@interface ActionFactory : NSObject {

}

+ (CCAction *)moveByFrom:(CGPoint)from to:(CGPoint)to inSecond:(ccTime)second;
+ (CCAction *)moveByFrom:(CGPoint)from to:(CGPoint)to speed:(float)speed;
+ (CCAction *)moveByFrom:(CGPoint)from to:(CGPoint)to degree:(float)degree speed:(float)speed;
+ (CCAction *)moveByFrom:(CGPoint)from degree:(float)degree speed:(float)speed;
+ (CCAction *)moveByFrom:(CGPoint)from acceleration:(UIAcceleration *)acceleration;

@end
