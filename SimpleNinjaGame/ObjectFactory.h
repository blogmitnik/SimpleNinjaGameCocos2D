//
//  ObjectFactory.h
//  SimpleNinjaGame
//
//  Created by David Wang on 2011/5/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class GameObject;
@class HelloWorld;

@interface ObjectFactory : NSObject {
}

+(GameObject *)enemy;
+(GameObject *)bullet;

@end
