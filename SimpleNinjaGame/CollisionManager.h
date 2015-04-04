//
//  CollisionManager.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/4/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CollisionManager : NSObject {
	
}

-(BOOL) isCollided:(CCNode *) source objectUnderCollision:(CCNode *) target;

@end